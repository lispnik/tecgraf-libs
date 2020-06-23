#!/usr/bin/env bash
set -e
TMP=`mktemp -d -t update.sh.XXXXXX`
trap "rm -r $TMP* 2>/dev/null" EXIT

dest=libs/

cd_version=5.13
im_version=3.14
iup_version=3.29

linux_version=54
windows_version=16

find "$dest" -type f -exec rm '{}' \;
while read url; do
    if [[ "$url" =~ .*/([^/]*(Linux|Win).*)/download$ ]]; then
        filename=${BASH_REMATCH[1]}
        platform=${BASH_REMATCH[2]}
        curl -L "$url" >"$TMP"/"$filename"
        archive="$TMP"/"$filename"
        case "$platform" in
            Win)
                unzip -d "$dest" -o "$archive" \*.dll
                ;;
            Linux)
                tar xf "$archive" -C "$dest" --wildcards \*.so --transform='s/.*\///'
                find "$dest" -type f -name \*.so -exec patchelf --set-rpath '$ORIGIN' '{}' \;
                ;;
            *)
        esac
        
    fi
done <<EOF
https://sourceforge.net/projects/canvasdraw/files/${cd_version}/Linux%20Libraries/cd-${cd_version}_Linux${linux_version}_64_lib.tar.gz/download
https://sourceforge.net/projects/canvasdraw/files/${cd_version}/Windows%20Libraries/Dynamic/cd-${cd_version}_Win64_dll${windows_version}_lib.zip/download
https://sourceforge.net/projects/imtoolkit/files/${im_version}/Linux%20Libraries/im-${im_version}_Linux${linux_version}_64_lib.tar.gz/download
https://sourceforge.net/projects/imtoolkit/files/${im_version}/Windows%20Libraries/Dynamic/im-${im_version}_Win64_dll${windows_version}_lib.zip/download
https://sourceforge.net/projects/iup/files/${iup_version}/Linux%20Libraries/iup-${iup_version}_Linux${linux_version}_64_lib.tar.gz/download
https://sourceforge.net/projects/iup/files/${iup_version}/Windows%20Libraries/Dynamic/iup-${iup_version}_Win64_dll${windows_version}_lib.zip/download
EOF

(cd "$TMP"; sha256sum *.zip *.tar.gz) >"$dest"/sha256sum.txt
