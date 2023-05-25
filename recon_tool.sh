#!/bin/bash

APYKEYGITHUB="apiyusefe"
amass=~/.config/amass/config.ini
subfinder=~/.config/subfinder/provider-config.yaml
export VTAPIKEY=27e7e0504d6e1443ce89c05c620cb9e7d8300f1cfbae4d54375375764bbae4e3
words=~/bounty2.sh/wordlists/best-dns-wordlist.txt
resolvers=~/.config/puredns/resolvers.txt


# Subdomain Enumeration
assetfinder --subs-only "$1" | tee -a assetfinder.txt

#amass
amass enum -passive -d "$1" -config "$amass" -o ~/bounty.sh/recon/"$1"/amass.txt

#subfinder
subfinder -silent -all -d "$1" -pc "$subfinder" -o subfinder.txt

#findomain -t "$1" --quiet | tee -a findomain.txt

#gau subdomains
gau --subs "$1" | unfurl -u domains | tee -a gau.txt

#virusetotale
python3 ~/Documents/tools_bug_bounty/subdomain_enum/virustotal-subdomain-scraper/vt-subdomains.py "$1" | tee -a virusetotal.txt

# Wayback URLs
waybackurls "$1" | unfurl -u domains | tee -a waybackurls.txt

# Censys Subdomain Finder
python3 ~/Documents/tools_bug_bounty/subdomain_enum/censys-subdomain-finder/censys-subdomain-finder.py --censys-api-id 55576a3f-8337-4217-bae5-2057287c29e0 --censys-api-secret 9C7Q7DXC195BpM6ppc8vf2KyVNV1mPJe "$1" | tr -d " " | tr -d "-" -o censys.txt

# CTFR
python3 ~/Documents/tools_bug_bounty/subdomain_enum/ctfr/ctfr.py -d "$1" | tee -a ctfr.txt

# Gospider
gospider -d 0 -s "$i" -c 5 -t 100 -d 5 --blacklist jpg,jpeg,gif,css,tif,tiff,png,ttf,woff,woff2,ico,pdf,svg,txt | grep -Eo '(http|https)://[^/"]+' | anew gospider.txt

# Chaos
chaos -d "$1" -o chaos1 -silent | tee -a chaos.txt

# Shuffledns
shuffledns -d "$1" -silent -w "$words" -r "$resolvers" | tee -a shuffledns

# GitHub Subdomains
github-subdomains -t "$APYKEYGITHUB" -d "$1" | tee -a gethub.txt

