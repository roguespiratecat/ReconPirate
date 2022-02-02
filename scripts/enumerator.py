# Enumerator V1
import csv
import os
import argparse

homedir =os.getcwd()

parser = argparse.ArgumentParser(description='Search for Strings in Files')
parser.add_argument('-p','--path',       help='directory path ex: /opt/app/', type=str)
parser.add_argument('-e','--extension',  help='file extension ex: .java', type=str)
parser.add_argument('-s','--search',  help='Regex to search in files', type=str)
parser.add_argument('-o','--output', help='File to write result to', type=str)

args = parser.parse_args()


if args.path == None and args.extension == None and args.extension == None :
	print(f"[!] Missing required Inputs --path, --extension --search")
	print(f"[!] Usage : python3 python3 enumerator.py -p '/path/to/target/dir' -e '.java' -s mySearchTerm ")
else:
	path =args.path
	ext= args.extension
	search=args.search

	filelist = []
	resultList =[]
	for root, dirs, files in os.walk(path):
		for file in files:
			if(file.endswith(ext)):
				filelist.append(os.path.join(root,file))
	
	for filepath in  filelist:
		with open(filepath) as fp:
			line = fp.readline()
			cnt = 1
			while line:
				if search in line:
					print("Line {}: {}".format(cnt, line.strip()))
					resultList.append("Line {}: {}".format(cnt, line.strip()))
					line = fp.readline()
					cnt += 1
	if args.output != None:
		textfile = open(args.output, "w")
		for element in resultList:
			textfile.write(element + "\n")
			textfile.close()


