#!/usr/bin/env bash

tempdir="C:/temp2"
patchdir="/d/DATA/Websites/Betterbird/quicktext-for-betterbird/"

cd "$tempdir" || exit 1

if [ ! -d "quicktext" ]; then
    git clone https://github.com/jobisoft/quicktext
    cd "quicktext" || exit 1
else
    cd "quicktext" || exit 1
    git reset --hard
    git pull
fi

sed -i -e 's/Quicktext is only supported on Thunderbird/Quicktext is only supported on Thunderbird and Betterbird/' src/dialogs/options/options.html
sed -i -e 's/Quicktext is only supported on Thunderbird/Quicktext is only supported on Thunderbird and Betterbird/' src/scripts/background.js

sed -i -e 's/browserInfo.name !== "Thunderbird"/browserInfo.name !== "Thunderbird" && browserInfo.name !== "Betterbird"/' src/dialogs/options/options.js
sed -i -e 's/browserInfo.name !== "Thunderbird"/browserInfo.name !== "Thunderbird" \&\& browserInfo.name !== "Betterbird"/' src/scripts/background.js

sed -i -e 's/{8845E3B3-E8FB-40E2-95E9-EC40294818C4}/quicktext-fixed-for-BB@betterbird.eu/' src/manifest.json
sed -i -e 's/"name": "Quicktext"/"name": "Quicktext for Betterbird"/' src/manifest.json
sed -i -e 's@https://github.com/jobisoft/quicktext@https://www.betterbird.eu/addons/#Quicktext-for-BB@' src/manifest.json
sed -i -e 's@https://raw.githubusercontent.com/jobisoft/quicktext/refs/heads/Main/updates.json@https://www.betterbird.eu/downloads/Addons/updates.json@' src/manifest.json
sed -i -e 's/John Bieling/John Bieling with tweaks by Betterbird/' src/manifest.json

# Inject license check.
sed -i -e "/getAPI(context) {/r ${patchdir}quicktext-license.js" src/api/FileSystemAccess/implementation.js

# Inject invocation of Experiment APIs.
sed -i -e 's/const browserInfo =/await browser.FileSystemAccess.getQuicktextFilePaths("");const browserInfo = /' src/scripts/background.js

version=$(awk -F\" '/"version"/ {print $4; exit}' src/manifest.json)

cd src
7z a -r ../quicktext-for-BB-$version.xpi .
cd ..

echo "Find the patched add-on here:"
ls -la $tempdir/quicktext/quicktext-for-BB-$version.xpi
