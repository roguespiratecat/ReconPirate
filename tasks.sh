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

nmapInitial () {

	nmap -sC -sV -oN nmap/$1_nmap.txt
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
   echo "[*] Starting Google Dork Testing "
   readarray -t array < ./$1_googleDorks.txt
   for e in "${array[@]}"
   do
	python3 degoogle.py "$e" > degoogle.txt
   done
   echo "[*] Finished Google Dork Testing results in $(pwd)/$1_googleDorks.txt"
}

generateGithubDorks ()  {
	  ./githubDorks.sh $1 > ./dorking/$1-githubDorks.txt
}


COLUMNS=12
PS3=" Recon Pirate Available Tasks: "
options=("--Https-Probe [!] (Probe amass enumerated Domains)" "--Content-Discovery [!] (Start Simple Content Discovery)" "--Amass-Enum-List [!] Show All Ammass Enumerations" "--Amass-Enum-Show [!] (Show Amass Enumeration)" "--Mass-Scan [!] (Start Mass Scan)" "--Web-Screen-Shots [!] (Screenshot Web Sites from Domain Lists)" "--Git-Dorks [!] (Generates List Of Github Dorks For provided Domain)" "--Start-Simple-Server [!] (Start A Simple Web Browser)" "--Google-Dork-Test [!] (Test domain agains all Google Dorks)" "--Start-Recon-NG [!] (Starts Quick Recon-NG Console)" "--nmap-inital [!] (Initial nmap scan)" "--Quit [!] (Exit App)" )
select opt in "${options[@]}"
do
    case $opt in
	    "--Https-Probe [*] (Probe amass enumerated Domains)")
            echo "[*] Probing Http Servers "
            httProbe $domain
            cat ./httprobe.txt 
            echo "[*] Probe Finished"
            echo "[*] Results in $(pwd)/httprobe.txt"
            exit 0
            ;;
        "--Content-Discovery [!] (Start Simple Content Discovery)")
             echo "[*] Crawling Domains"
             siteCrawl $domain
             echo "[*] Process Finished"
             echo "[*] Results in $(pwd)/content-discovery/"
             ls content-discovery
             exit 0
            ;;
        "--Amass-Enum-List [!] (Show All Amass Enumerations)")
            amassEnumList $domain
            ;;
        "--Amass-Enum-Show [!] (Show Amass Enumeration)")
	        amassEnumShow $domain
		exit 0
	        ;;
        "--Mass-Scan [!] (Start Mass Scan)")
	         echo "[*] Starting Mass Scan"
             massScan $domain
             echo "[*] Process Finished"
             echo "[*] Results in $(pwd)/massScan.log"
             cat massScan.log
             exit 0
	        ;;
        "--Web-Screen-Shots [!] (Screenshot Web Sites from Domain Lists)")
	        eyewitness -f amass_$domain.txt  -d screenshots
		exit 0
	        ;;
        "--Git-Dorks [!] (Generates List Of Github Dorks For provided Domain)")
			echo "[*] Enter Domain Name "
			read target   
	        generateGithubDorks $target
	        cat /dorking/$target-githubDorks.txt
	        exit 0
	        ;;
	 "--Start-Simple-Server [!] (Start A Simple Web Browser)")
		 startSimpleServer 
		 exit 0
	        ;;
	"--Google-Dork-Test [!] (Test domain agains all Google Dorks)")
		runDorkTest $domain
		exit 0
		;;
	"--Start-Recon-NG [!] (Starts Quick Recon-NG Console)")
	        recon-ng
	        exit 0
		;;
	"--nmap-inital [!] (Initial nmap scan)")	
		echo "[*] Starting initial Nmap Scan"
		ip=$(dig +short $domain)
		nmap -sC -sV -oN nmap/$domain_nmapscan.txt $ip
		exit 0
		;;

        "--Quit [!] (Exit App)")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

