#!/bin/bash

declare -a desktopFiles=("/var/lib/snapd/desktop/applications/brave_brave.desktop"
                         "/var/lib/snapd/desktop/applications/chromium_chromium.desktop"
                         "/usr/share/applications/microsoft-edge.desktop"
                         "/usr/share/applications/google-chrome.desktop"
                         "/usr/share/applications/vivaldi-stable.desktop")

params="--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder"

declare -a desktopFiles2=()  # None now, all browsers upgraded to version 131

params2="--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiVideoDecodeLinuxGL"

function processDeskTopFiles() {
  dtf=("$@")
  first=true
  for input in "${dtf[@]}"
  do
    if $first; then
      first=false
      continue # The first "element" is the params, so skip it
    fi
    tmpFile=/tmp/$(basename "$input".tmp)
    fileChanged=false
    while read -r line
      do
        if [[ $line == Exec*  &&  $line != *$1 ]]
        then
            echo "$line"" ""$1" >> "$tmpFile"
            fileChanged=true
        else
            echo "$line" >> "$tmpFile"
        fi
    done < "$input"
    if $fileChanged; then
      cp "$tmpFile" "$HOME/.local/share/applications/$(basename -a "$input")"
    fi
    rm "$tmpFile"
  done
}

processDeskTopFiles $params "${desktopFiles[@]}"
# processDeskTopFiles $params2 "${desktopFiles2[@]}"
