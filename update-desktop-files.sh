#!/bin/bash

declare -a desktopFiles=("/var/lib/snapd/desktop/applications/brave_brave.desktop"
                         "/var/lib/snapd/desktop/applications/chromium_chromium.desktop"
                         "/usr/share/applications/google-chrome-beta.desktop"
                         "/usr/share/applications/google-chrome.desktop"
                         "/usr/share/applications/microsoft-edge.desktop")

params="--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiVideoDecodeLinuxGL"

for input in "${desktopFiles[@]}"
do
  tmpFile=$(basename "$input".tmp)
  printf "" > "$tmpFile"
  while read -r line
    do
      if [[ $line == Exec*  &&  $line != *$params ]]
      then
          echo "$line"" "$params >> "$tmpFile"
      else
          echo "$line" >> "$tmpFile"
      fi
  done < "$input"
  cp "$tmpFile" "$input"
  rm "$tmpFile"
done

