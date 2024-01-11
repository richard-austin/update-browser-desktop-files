# update-browser-desktop-files
#### Simple script to restore browser command line parameters after software update
I use Ubuntu 23.10 with VAAPI for hardware video decoding on my browsers. To enable hardware decoding in Chromium based 
browsers on Linux, you need to add command line parameters ("--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiVideoDecodeLinuxGL).
To make these permanent, you can put them at the end of lines starting with "Exec" in their .desktop files 

This is straightforward enough, but the problem is, whenever there is a software update to any of these browsers, its 
.desktop file is overwritten so you have to do it again. After getting fed up with this, I decided to write this script.

Run it as root and it will ensure that any Exec lines in the listed desktop files that don't end in the required 
parameters will have them appended, Any that still do have them will be left alone.

## Setting up
The desktopFiles array should contain the full paths of all the browser desktop files you want to be able to keep the
command line parameters on. Mine is :-

```bash
declare -a desktopFiles=("/var/lib/snapd/desktop/applications/brave_brave.desktop"
                         "/var/lib/snapd/desktop/applications/chromium_chromium.desktop"
                         "/usr/share/applications/google-chrome-beta.desktop"
                         "/usr/share/applications/google-chrome.desktop"
                         "/usr/share/applications/microsoft-edge.desktop")
```
The params variable should be set to the parameters you want to ensure are appended to the Exec lines in the files.
For VAAPI video decoding and encoding this is :-

```bash
params="--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiVideoDecodeLinuxGL"
```
## Running
Run the script as root :-
```bash
sudo ./update-desktop-files.sh
```

Thats it!
