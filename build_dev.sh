# filter files
rsync -anv dev .dev-tmp --exclude "**/node_modules" --exclude "**/cache" --exclude "**/.stfolder" --exclude "**/.stversions"

# zip files
tar -cf dev-sync.tar -C .dev-tmp .
# or compressed
# tar -zcf dev-sync.zip -C .dev-tmp .

# send to git
git push
