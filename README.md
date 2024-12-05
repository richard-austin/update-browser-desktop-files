# update-browser-desktop-files
#### Simple script to restore browser command line parameters after software update
I use Ubuntu 24.04 with VAAPI for hardware video decoding on my browsers. To enable hardware decoding in Google Chrome and Microsoft Edge 
on Linux, you need to add command line parameters ("--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiVideoDecodeLinuxGL).
For Chromium and Brave, it's --enable-features=AcceleratedVideoDecodeLinuxGL.
To make these permanent, you can put them at the end of lines starting with "Exec" in their .desktop files 

This is straightforward enough, but the problem is, whenever there is a software update to any of these browsers, its 
.desktop file is overwritten so you have to do it again. You can put the updated desktop files at ~/.local/share/applications
where they override the originals and are not overwritten, but every now and again an update changes the path to the browser icon
so the browser button disappears!
After getting fed up with this, I decided to write this script.

Run it and it will ensure that any Exec lines in the listed desktop files that don't end in the required 
parameters will have them appended, Any that still do have them will be left alone. The updated file will be copied to 
~/.local/share/applications where it will override the originally installed .desktop file. As it will be unaffected by 
subsequent updates, the VAAPI parameters will survive them, but sometimes icon paths etc are changed in updates, which 
would require this script to be re-run to take account of that.

## Setting up the script
The desktopFiles arrays should have corresponding command line parameters which are applied to all desktop files
listed in that array. The arrays should contain the full paths of all the browser desktop files you want to be able to keep the
corresponding command line parameters on. Mine are :-

For Browsers based on Chromium >= version 131 
```bash
declare -a desktopFiles=("/var/lib/snapd/desktop/applications/brave_brave.desktop"
                         "/var/lib/snapd/desktop/applications/chromium_chromium.desktop")

params="--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder"
```
For browsers based on Chromium < version 131
```bash
declare -a desktopFiles2=("/usr/share/applications/google-chrome.desktop"
                         "/usr/share/applications/microsoft-edge.desktop")

params2="--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiVideoDecodeLinuxGL"
```
The params variables are set to the parameters you want to ensure are appended to the Exec lines in the files listed 
in the corresponding array. The processDeskTopFiles function is called with the required Exec line parameters as the first argument
and the desktop files path array as the second, as below :-

```bash
processDeskTopFiles $params "${desktopFiles[@]}"
processDeskTopFiles $params2 "${desktopFiles2[@]}"
```

## Running the script
Run the script using your user account :-
```bash
./update-desktop-files.sh
```

That's it!
