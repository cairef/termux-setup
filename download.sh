# sdcard
# tar -xf /sdcard/dev-sync.tar -C .

select download_opt in git url file; do
  case $download_opt in
  git)
    # curl https://raw.githubusercontent.com/cairef/termux-setup/main/install.sh | bash
    pkg install -y git
    git clone https://github.com/cairef/termux-setup termux-setup
    cd termux-setup
    bash install.sh
    break
    ;;
  url)
    read -p "Type the download url below" url
    # curl $url | bash
    curl $url >termux-setup.tar
    tar -xf termux-setup.tar -C termux-setup
    cd termux-setup
    bash install.sh
    break
    ;;
  file)
    read -p "Type the file path below" file
    tar -xf "$file" -C termux-setup
    cd termux-setup
    bash install.sh
    break
    ;;
  esac
done
