#!/bin/bash

# Gathering JS Files
mkdir js_urls
cd js_urls

alias SecretFinder.py="python3 ~/Documents/tools_bug_bounty/leak_secrets/secretfinder/SecretFinder.py"
alias collector.py="python3 ~/Documents/tools_bug_bounty/subdomain_enum/collector.py"
alias linkfinder.py="python3 ~/Documents/tools_bug_bounty/url_enum/sub_in_js/LinkFinder/linkfinder.py"

cd ../urls_enum
gf urls | grep -iE '\.js' | grep -iEv '(\.jsp|\.json)' | tee -a ../js_urls/js.txt
cd ../js_urls

cat ../urls_enum/getSrc.txt | grep -iE '\.js' | grep -iEv '(\.jsp|\.json|\.css)' | tee -a scr.txt

cat ../urls_enum/gospiderUrls.txt | grep -Eo "(http|https)://[^/\"].*\.js+" | sed "s#\] \- #\n#g" | tee -a gospiderJS.txt

cat ../alive.txt | getJS --complete | anew JS-get.txt

cat ../alive.txt | getJS --complete --method POST | anew JS-post.txt

subjs -i ../alive.txt | tee -a subjs.txt

cat js.txt JS-get.txt JS-post.txt gospiderJS.txt subjs.txt scr.txt | sort -u | uro | tee -a final_js.txt

cat final_js.txt | anti-burl | awk '{print $4}' | sort -u >> AliveJs.txt
xargs -a AliveJs.txt -n 2 -I@ bash -c "echo -e '\n[URL]: @\n'; linkfinder.py -i @ -o cli | tee -a linkfinder.txt"
cat AliveJs.txt | python3 collector.py output
xargs -a output/urls.txt -I@ bash -c "SecretFinder.py -i {} -o cli | sort -u >> output/resultJSPASS"
