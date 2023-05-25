mkdir secrets
cd secrets

alias SecretFinder.py="python3 ~/Documents/tools_bug_bounty/leak_secrets/secretfinder/SecretFinder.py"
alias zile.py="python3 ~/Documents/tools_bug_bounty/leak_secrets/zile/zile.py"

cat ../alive.txt | xargs -n1 -I{} sh -c 'echo -e "\033[0;31m {}"; SecretFinder.py -i {} -e -o cli | tee -a secretfinder.txt' 

cat ../js_urls/final_js.txt | jsleak -c 20 -l -s -k -e | tee -a jsleak.txt

cat ../js_urls/final_js.txt | jsubfinder search -s -o jsubfinder.txt

cat ../js_urls/final_js.txt | zile.py --request --colored | tee -a zile.txt
