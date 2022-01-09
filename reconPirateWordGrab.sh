wordgrab() {
  url=$1
  tmpfile="$(date "+%s")"
  curl -sLk -m 3 -A "Mozilla/5.0 (X11; Linux; rv:74.0) Gecko/20100101 Firefox/74.0" https://$url | html2text | egrep -io "[0-9a-zA-Z\-]+" | tr '[:upper:]' '[:lower:]' | sed -r "s/^[^a-z]+//g" | sed -r "s/[^a-z0-9]+$//g" | sort -fu | tee -a $tmpfile | tr '-' '.'  | tee -a $tmpfile | tr "." "\n" >> $tmpfile
  cat $tmpfile | sort -fu
  rm $tmpfile
}

wordgrab $1