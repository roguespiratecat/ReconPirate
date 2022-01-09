function sslsub() {
  timeout 3 openssl s_client -showcerts -servername $1 -connect $1:443 <<< "Q"  2>/dev/null | openssl x509 -text -noout | grep DNS | tr ',' '\n' | cut -d ':' -f 2 | sort -fu
}

sslsub $1