<img width="500" height="500" alt="BLACKWS" src="https://github.com/user-attachments/assets/776e5394-3ac9-4c65-afe5-c8eb37b9ea46" />

# <summary><strong>BLACKWS ( BLACKARCH WEB SECURITY TOOLS ) </strong></summary>

## NOTE : "THIS IS JUST AN INSTALLER FOR WEBSEC"
I created this tool as a pentest and ethical hacking installer for the Arch Linux distribution. It focuses on web security and also ignores tools with problematic/invalid PGP keys from the official BlackArch maintainer.

## ORIGINAL AND THANKS FOR BLACKARCH
[BLACKARCH](https://blackarch.org/index.html)

## How To Use
```
https://github.com/Bangkit-eldhian24/Blackws.git
cd Blackws
sudo chmod +x Blackws
mv Blackws /usr/local/bin/Blackws

```
all in one
```
Blackws "blackarch-webapp blackarch-recon blackarch-scanner blackarch-fuzzer blackarch-code-audit blackarch-proxy blackarch-dos blackarch-exploitation blackarch-cracker blackarch-fingerprint blackarch-sniffer blackarch-database"
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
<img width="923" height="1058" alt="swappy-20251208_162051" src="https://github.com/user-attachments/assets/95aa1208-1fde-43ef-a039-edf5e3d163ec" />




