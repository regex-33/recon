#!/bin/bash

# Create the directory and copy the 'alive.txt' file
mkdir urls_enum
cp alive.txt urls_enum/alive.txt
cd urls_enum

# Set the token variable
export token=""

# Define the alias for getSrc.py
alias getSrc.py="python3 ~/Documents/tools_bug_bounty/subdomain_enum/getsrc.py"

# Gather URLs using waybackurls and save them to 'way.txt'
cat alive.txt | waybackurls | tee -a way.txt

# Gather URLs using gau and save them to 'gau.txt'
cat alive.txt | gau | tee -a gau.txt

# Use katana to list URLs and save them to 'katana.txt'
katana -list alive.txt -o katana.txt

# Use hakrawler to gather URLs and save them to 'hakrawler.txt'
cat alive.txt | hakrawler | tee -a hakrawler.txt

# Use paramspider to gather URLs and save them to 'paramspider.txt'
cat alive.txt | xargs -I@ sh -c 'python3 paramspider.py -d @ | grep ^http | tee -a paramspider.txt'

# Use github-endpoints to gather URLs and save them to 'githubEndpoints.txt'
cat alive.txt | xargs -I@ sh -c 'github-endpoints -t "$token" -d @ | tee -a githubEndpoints.txt'

# Use getSrc.py to gather URLs and save them to 'getSrc.txt'
cat alive.txt | getSrc.py | tee -a getSrc.txt

# Use gospider to gather URLs and save them to 'gospiderUrls.txt'
cat alive.txt | xargs -I@ sh -c 'gospider -s "$1" -o output -c 10 -d 1 --other-source --include-subs --blacklist ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico)" --robots --sitemap --subs --js | tee -a gospiderUrls.txt'

# Combine all the gathered URLs and remove duplicates
cat way.txt getSrc.txt gospiderUrls.txt paramspider.txt githubEndpoints.txt gau.txt katana.txt hakrawler.txt | sort -u | tee -a final-urls.txt
