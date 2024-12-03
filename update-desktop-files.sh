#!/bin/bash

declare -a desktopFiles=("/var/lib/snapd/desktop/applications/brave_brave.desktop"
                         "/var/lib/snapd/desktop/applications/chromium_chromium.desktop")

params="--enable-features=AcceleratedVideoDecodeLinuxGL"

declare -a desktopFiles2=("/usr/share/applications/google-chrome-beta.desktop"
                         "/usr/share/applications/google-chrome.desktop"
                         "/usr/share/applications/microsoft-edge.desktop")

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
processDeskTopFiles $params2 "${desktopFiles2[@]}"
