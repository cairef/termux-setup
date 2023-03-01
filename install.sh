#!/data/data/com.termux/files/usr/bin/bash

export dev="$HOME/dev"

lns() {
  if [ ! -L $2 ]; then
    if [ ! -d $(dirname $2) ]; then
      mkdir $(dirname $2)
    fi

    ln -s $1 $2
  fi
}
fix-shebang() {
  if [ "$(command -v $1)" != "" ]; then
    termux-fix-shebang $(command -v $1)
    echo "$1 shebang fixed"
  else
    echo "WARN: $1 not found, cant fix shebang!"
  fi
}
self_destroy_folder() {
  local to_del_path=$(pwd)
  cd ..
  rm -r $to_del_path
}

if [ ! -e ~/storage ]; then
  termux-setup-storage
fi

select install_opt in full full_non_root essentials upgrade_only; do
  echo "Upgrading..."
  pkg upgrade -y -o DPkg::options::="--force-all"

  case $install_opt in
  full)
    echo "Installing full..."
    pkg install -y root-repo
    pkg install -y \
      openssh p7zip zip git nodejs yarn curl wget syncthing vim nano iproute2 \
      ffmpeg rsync rclone syncthing fish zsh termux-tools binutils python2 python3
    yarn global add nodemon ts-node typescript
    break
    ;;
  full_non_root)
    echo "Installing full-non-root..."
    pkg install -y \
      openssh p7zip zip git nodejs yarn curl wget syncthing vim nano iproute2 \
      ffmpeg rsync rclone syncthing fish zsh termux-tools binutils python2 python3 tar
    yarn global add nodemon ts-node typescript
    break
    ;;
  essentials)
    echo "Installing essentials..."
    pkg install -y \
      openssh zip tar git syncthing vim nano iproute2 termux-tools
    break
    ;;
  upgrade_only)
    echo "No additional package installed!"
    break
    ;;
  esac
done

fix-shebang $(command -v node)
fix-shebang $(command -v nodemon)
fix-shebang $(command -v ts-node)
fix-shebang $(command -v yarn)

if [ -e ~/../usr/etc/motd ]; then
  rm ~/../usr/etc/motd
  echo "motd deleted"
fi

if [ ! -d ~/dev ]; then
  source ~/.bashrc
  echo "dev not found!"
  echo "starting local init"
  source res/init
  echo "opening syncthing..."
  wsync
fi
while [ -d ~/dev ]; do
  echo "dev not found. type enter to continue when dev exists"
  read
done

echo "dev found! linking files..."
lns $dev/termux-install/init ~/.bashrc
lns $dev/termux-install/boot ~/.termux/boot/boot
lns $dev/termux-install/props ~/.termux/termux.properties
lns $dev/termux-install/editor ~/bin/termux-file-editor
lns $dev/termux-install/url ~/bin/termux-url-opener

echo "rechecking upgrade"
u

echo "running bashrc..."
source ~/.bashrc

echo "running fboot..."
fboot

echo "setupping keyboard..."
setup_kb

# TODO
# echo "cleaning install folder"
# self_destroy_folder

echo Install Success
