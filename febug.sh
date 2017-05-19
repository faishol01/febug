#!/bin/bash

#HEADER
satu(){
	echo "================"
	echo "| Compiling... |"
	echo "================"
}

dua(){
	echo "================"
	echo "| Compile Done |"
	echo "================"

	echo "==================="
	echo "| RUNNING PROGRAM |"
	echo "==================="
	echo ""
}
#END HEADER

usage(){
	echo "Usage: febug <SOURCE CODE> [MODE]"
	echo ""
	echo "[MODE]"
	echo "  -c, --compile-run         compile and run only. Input using STDIN."
	echo "  -i, --interactive         interactive mode."
	echo "  -n, --normal              normal mode. Input using FILE."
	echo ""
	echo "MODE will use '-n' for the default."
	echo ""
	echo "			     FeBug version 1.1.0"
	echo "		Developed by Muhammad Faishol Amirul Mukminin"
	exit 0
}

interaktif(){
	satu
	#Compile the source code and show the stderr
	g++ $FILE.cpp -o $FILE
	g++ $FILE.judge.cpp -o $FILE.judge
	dua

	mkfifo pipa pipa2

	rm $FILE.out
	cat $FILE.in > pipa | ./$FILE.judge < pipa | tee pipa2 >> $FILE.out | ./$FILE < pipa2 | tee pipa >> $FILE.out

	rm pipa pipa2

	echo ""
	echo "============START INTERACTION============"
				cat $FILE.out
	echo "=============END INTERACTION============="
	echo ""

			cat verdict
			rm verdict
}

normal(){
	satu
	#Compile the source code and show the stderr
	g++ $FILE.cpp -o $FILE
	dua
	echo "============START OUTPUT============"
	#Show the output using stdout and redirect to file
	# "time" use for get command running time
	{ time ./$FILE < $FILE.in | tee $FILE.out ; } 2> waktu
	echo "=============END OUTPUT============="
	echo ""

	echo "================"
	echo "| RUNNING TIME |"
	echo "================"
	#Show command running time
	cat waktu
	rm waktu
}

hanyaCompile(){
	satu
	#Compile the source code and show the stderr
	g++ $FILE.cpp -o $FILE
	dua

	echo "============START PROGRAM============"
	./$FILE
	echo "=============END PROGRAM============="
}

args=("$@")
FILE=${args[0]/.cpp/}

if [ $# -lt 1 ]; then
	usage
fi

clear

case "$2" in
	-c) hanyaCompile
	;;
	-i) interaktif
	;;
	-n) normal
	;;
	*) normal
	;;
esac

#Footer
echo ""
echo ""
echo "			     FeBug version 1.1.0"
echo "		Developed by Muhammad Faishol Amirul Mukminin"
# EOF
