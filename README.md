
# <summary><strong>BLACKARCH INSTALLER </strong></summary>

## NOTE : "THIS IS JUST AN INSTALLER FOR ETHICAL"
I created this tool as a pentest and ethical hacking installer for the Arch Linux distribution. It focuses on security and also ignores tools with problematic/invalid PGP keys from the official BlackArch maintainer.
I USED TO FOR MY OWN ARCH DISTRIBUTION, SO YEAH..


INSPIRED AND THANKS FOR [BLACKARCH](https://blackarch.org/index.html)

<details>
  <summary>BLACKWS WEBSEC installer</summary>

# <summary><strong>BLACKWS ( BLACKARCH WEB SECURITY TOOLS ) </strong></summary>

<img width="500" height="500" alt="BLACKWS" src="https://github.com/user-attachments/assets/776e5394-3ac9-4c65-afe5-c8eb37b9ea46" />

## **installing**

```
https://github.com/Bangkit-eldhian24/Blackws.git
cd Blackws/blackws
sudo chmod +x blackws.sh
mv Blackws /usr/local/bin/blackws.sh
```
all in one
```
blackws "blackarch-webapp blackarch-recon blackarch-scanner blackarch-fuzzer blackarch-code-audit blackarch-proxy blackarch-dos blackarch-exploitation blackarch-cracker blackarch-fingerprint blackarch-sniffer blackarch-database"
```
list all of available tools
```
sudo pacman -Sgg | grep blackarch | cut -d' ' -f2 | sort -u
```
To install a category of tools
```
sudo pacman -S blackarch-<category>
```
To see the blackarch categories
```
sudo pacman -Sg | grep blackarch
```
To search for a specific package
```
pacman -Ss <package_name>
```

## LIST
blackarch-webapp       → Web app testing (SQLMap, Nikto, etc)

blackarch-recon        → Information gathering (Nmap, Amass, etc)

blackarch-scanner      → Vulnerability scanners (OpenVAS, etc)

blackarch-fuzzer       → Fuzzing tools (AFL, Wfuzz, etc)

blackarch-code-audit   → Source code analysis

blackarch-proxy        → Proxy tools (Burp Suite, ZAP, etc)

blackarch-dos          → DoS testing tools

blackarch-exploitation → Exploit frameworks (Metasploit, etc)

blackarch-cracker      → Password crackers (John, Hashcat, etc)

blackarch-fingerprint  → Service fingerprinting

blackarch-sniffer      → Network sniffers (Wireshark, tcpdump, etc)

blackarch-database     → Database tools (SQLMap, etc)

## ETC / TROUBLE SHOOTING
if ur tools are not installing u can tried 
```
sudo pacman -S "$PACKAGE_GROUP" --needed
```
or read [BLACKARCH OFFICIAL](https://blackarch.org/downloads.html)
u can change var in this code like how to show dir list in case, example
```
PACKAGE_GROUP=$1
echo "  $0 blackarch-webapp"
```
HYPRLAND VIEW
<img width="923" height="1058" alt="swappy-20251208_162051" src="https://github.com/user-attachments/assets/95aa1208-1fde-43ef-a039-edf5e3d163ec" />

NORMAL VIEW

<img width="729" height="601" alt="Screenshot_20251208_163856" src="https://github.com/user-attachments/assets/9514ccd3-c444-45fb-b059-c1597ecc9ec9" />


</details>

============================================

<details>
  <summary>BAITXploit installer</summary>

# <summary><strong>BAITX ( blackarch installer tools )</strong></summary>

-----------------------------------------------------
MY TEST
```
**Total tools available across all categories: 4990**

**Total installed: 4837**
```
-----------------------------------------------------
## **installing**

```
https://github.com/Bangkit-eldhian24/Blackws.git
cd Blackws/baitx
sudo chmod +x BAITX.sh
mv Blackws /usr/local/bin/BAITX.sh
```
or
```
sudo install -m 755 baitx.sh /usr/local/bin/baitx
```

## LIST

<img width="749" height="1017" alt="swappy-20251211_014615" src="https://github.com/user-attachments/assets/a75b3766-a362-4a4c-ba65-8d984c55d601" />


## ETC / TROUBLE SHOOTING

```
# FIX 1: used file, no array
pacman -Sgq "$category" > "$pkg_file" 

# FIX 2: Batch install
current_batch=()
if [ ${#current_batch[@]} -ge 5 ]; then
    sudo pacman -S "${current_batch[@]}"
    current_batch=()
    sudo pacman -Sc --noconfirm  # ← Clear cache!
fi
```
```
sudo pacman -Sc --noconfirm
```

intrested, whats going oon at background??
```
sudo tail -f /var/log/pacman.log
```
check pacman 
```
ls /var/lib/pacman/db.lck
```


TERMINAL VIEW ( old view )
<img width="1807" height="1015" alt="swappy-20251211_015231" src="https://github.com/user-attachments/assets/06212003-1afc-48ff-93d2-ac7716d84de9" />

<img width="1920" height="1080" alt="20251211005541" src="https://github.com/user-attachments/assets/c4216815-7370-4b3d-b6c5-7e4fb7faf5d3" />

<img width="499" height="969" alt="swappy-20251211_015817" src="https://github.com/user-attachments/assets/f287631f-8f4f-4cc1-8ee1-61f01ac780db" />

NEW OUTPUT

<img width="719" height="978" alt="Screenshot_20251215_205647" src="https://github.com/user-attachments/assets/01945cac-c3d6-4db2-8d48-ae2481d5a5f8" />


</details>


