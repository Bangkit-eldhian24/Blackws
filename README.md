
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
cd Blackws
sudo chmod +x Blackws
mv Blackws /usr/local/bin/Blackws
```
all in one
```
Blackws "blackarch-webapp blackarch-recon blackarch-scanner blackarch-fuzzer blackarch-code-audit blackarch-proxy blackarch-dos blackarch-exploitation blackarch-cracker blackarch-fingerprint blackarch-sniffer blackarch-database"
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

<details>
  <summary>BAITXploit installer</summary>

Isi yang disembunyikan di sini.

</details>


