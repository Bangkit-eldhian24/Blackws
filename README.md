
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
nigga
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


## ETC / TROUBLE SHOOTING

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
*Structure*
```
~/baitx/
├── checkup/
│   ├── checkbaitx.txt          # Main log (your requested location)
│   ├── installed_packages.txt  # Package index for fast uninstall
│   ├── failed_packages.txt     # Failed attempts
│   └── session_logs/           # Per-session logs
└── backups/
    └── pre_install_state_*.txt # System snapshots

◄ 0s ◎ tree                           ⌂/baitx 22:27
.
├── backups
│   ├── pre_install_state_20260204_003014_70114.txt
│   └── pre_install_state_20260204_171021_3706.txt
└── checkup
    ├── checkbaitx.txt
    ├── failed_packages.txt
    ├── installed_packages.txt
    ├── report_20260204_004502.txt
    ├── report_20260204_004650.txt
    └── session_logs
        ├── session_20260204_001819_68995.log
        ├── session_20260204_001843_69078.log
        ├── session_20260204_003014_70114.log
        ├── session_20260204_004041_72734.log
        ├── session_20260204_171002_3532.log
        ├── session_20260204_171021_3706.log
        ├── session_20260209_220902_14673.log
        ├── session_20260209_221458_15281.log
        ├── session_20260209_221530_15415.log
        ├── session_20260209_221557_15479.log
        ├── session_20260209_222147_15764.log
        ├── session_20260209_222220_16146.log
        └── session_20260209_222403_17636.log

4 directories, 20 files
```


TERMINAL VIEW 
<img width="933" height="689" alt="swappy-20260209_222332" src="https://github.com/user-attachments/assets/efad753f-c04f-48aa-ba86-4c859118b762" />

<img width="448" height="492" alt="swappy-20260209_222450" src="https://github.com/user-attachments/assets/584a1acc-5bba-44eb-b61f-0fb01db45fa6" />


</details>


