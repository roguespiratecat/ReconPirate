#!/bin/bash

domain=DOMAIN


httProbe ()  {
	echo "[*] Probing active Web responses on subdomains"
	cat ./amass_$1.txt | httprobe > ./httprobe.txt
	cat ./httprobe.txt
}

siteCrawl () {
	echo "[*] Starting Initial Content Discovery on Discovered Domains"
	readarray -t array < ./amass_$1.txt
	for e in "${array[@]}"
	do
		./reconPirateDomainScrape.sh "$e" >> ./content-discovery/"$1".txt
	done

	rm -r *.js
	rm -r *js*
}

amassEnumList () {
	amass db -dir amass_$1_db -list
}

startSimpleServer () {
   python3 -m http.server 9390
}

amassEnumShow () {
	amass db -dir amass_$1_db -show 
}

massScan () {
	./dnmasscan amass_$1.txt dns.log -p80,443 -oG massScan.log
}

screenshotSites () {
  echo "[*] Not Implemented"
}

runDorkTest () {
   echo "[*] Starting Initial Content Discovery on Discovered Domains"
   readarray -t array < ./$1_googleDorks.txt
   for e in "${array[@]}"
   do
	python3 degoogle.py "$e" > degoogle.txt
   done
}

generateGithubDorks ()  {
	  ./githubDorks.sh $1 > ./dorking/$1-githubDorks.txt
}


#!/bin/bash
# Bash Menu Script Example

PS3='Recon Pirate Available Tasks: '
options=("--Https-Probe" "--Content-Discovery" "--Amass-Enum-List" "--Amass-Enum-Show" "--Mass-Scan" "--Web-Screen-Shots" "--Git-Dorks" "--Start-Simple-Server" "--Google-Dork-Test" "--Quit")
select opt in "${options[@]}"
do
    case $opt in
        "--Https-Probe")
            echo "[*] Probing Http Servers "
            httProbe $domain
            cat ./httprobe.txt 
            echo "[*] Probe Finished"
            echo "[*] Results in $(pwd)/httprobe.txt"
            exit 0
            ;;
        "--Content-Discovery")
             echo "[*] Crawling Domains"
             siteCrawl $domain
             echo "[*] Process Finished"
             echo "[*] Results in $(pwd)/content-discovery/"
             ls content-discovery
             exit 0
            ;;
        "--Amass-Enum-List")
            amassEnumList $domain
            ;;
        "--Amass-Enum-Show")
	        amassEnumShow $domain
		exit 0
	        ;;
        "--Mass-Scan")
	         echo "[*] Starting Mass Scan"
             massScan $domain
             echo "[*] Process Finished"
             echo "[*] Results in $(pwd)/massScan.log"
             cat massScan.log
             exit 0
	        ;;
        "--Web-Screen-Shots")
	        eyewitness -f amass_$domain.txt  -d screenshots
		exit 0
	        ;;
        "--Git-Dorks")
			echo "[*] Enter Domain Name "
			read target   
	        generateGithubDorks $target
	        cat /dorking/$target-githubDorks.txt
	        exit 0
	        ;;
	 "--Start-Simple-Server")
		 startSimpleServer 
		 exit 0
	        ;;
	"--Google-Dork-Test")
		runDorkTest $domain
		exit 0
		;;
        "--Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

