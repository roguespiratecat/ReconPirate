


wordList=$2
outdir=recon_$1



if [ -d "$outdir" ] ; then  
	echo "[*] Work Space Allready Initialized !"
	echo "[*] Please cd into $outdir and run ./tasks.sh"
	exit 0
fi

echo "[*] Creating Creating new Workspace at $(pwd)/$outdir"

if [ -z $wordList ] ; then
    echo '[*] No wordlist provided using default :\n/usr/share/amass/wordlists/deepmagic.com_top50kprefixes.txt '
    wordList=/usr/share/amass/wordlists/deepmagic.com_top50kprefixes.txt
fi

echo "[*] Creating Output Directories"
mkdir $outdir
mkdir $outdir/content-discovery
mkdir $outdir/screenshots
mkdir $outdir/dorking

echo ""
echo "[*] Generating Github Dorks"
echo ""

./scripts/githubDorks.sh $1 > $outdir/dorking/$1_githubDorks.txt

cat $outdir/dorking/$1_githubDorks.txt
echo ""
echo "[*] Starting Amass Enumeration That may take a while"
echo ""
#amass enum -active -d $1  -brute -w  $wordList  -dir $outdir/amass_$1_db -o $outdir/amass_$1.txt
echo ""
echo "[*] Finalizing Recon Setup"

awk '{sub(/DOMAIN/,"'$1'")}1' tasks.sh > $outdir/tasks.sh
chmod 777 $outdir/tasks.sh
cp -r scripts/* $outdir
echo "[*] Recon Setup Finished"
