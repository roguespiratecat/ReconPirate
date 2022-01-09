

wordList=$2

if [[ -z $wordList ]] ; then
    echo '[*] No wordlist provided using default :\n/usr/share/amass/wordlists/deepmagic.com_top50kprefixes.txt '
    wordList=/usr/share/amass/wordlists/deepmagic.com_top50kprefixes.txt
fi
echo "[*] Creating Output Directories"
outdir=recon_$1
mkdir $outdir
echo ""
echo "[*] Github Dorking across Repositories"
echo ""
./githubDorks.sh $1 > $outdir/githubDorks.txt
cat $outdir/githubDorks.txt
echo ""
echo "[*] Starting Amass Enumeration That may take a while"
echo ""
amass enum -active -d $1  -brute -w  $wordList  -dir $outdir/amass_$1_db -o $outdir/amass_$1.txt
echo ""
echo "[*] Probing active Web responses on subdomains"
cat $outdir/amass_$1.txt | httprobe > $outdir/httprobe.txt
cat $outdir/httprobe.txt
echo "[*] Starting Initial Content Discovery on Discovered Domains"

readarray -t array < $outdir/amass_$1.txt
mkdir $outdir/content-discovery
for e in "${array[@]}"
	./reconPirateDomainScrape "$e" > $outdir/content-discovery/"$e".txt
do
    
done
