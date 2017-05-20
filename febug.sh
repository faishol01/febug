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

footer(){
	echo ""
	echo "			     FeBug version 1.1.1"
	echo "		Developed by Muhammad Faishol Amirul Mukminin"
}

usage(){
	echo "Usage: febug <SOURCE CODE> [MODE]"
	echo ""
	echo "[MODE]"
	echo "  -c, --compile-run         compile and run only. Input using STDIN."
	echo "  -i, --interactive         interactive mode."
	echo "  -n, --normal              normal mode. Input using FILE."
	echo ""
	echo "MODE will use '-n' for the default."
	footer
	exit 0
}

interaktif(){
	satu
	#Compile the source code and show the stderr
	g++ $FILE.cpp -o $FILE -std=c++11
	g++ $FILE.judge.cpp -o $FILE.judge -std=c++11
	dua

	mkfifo pipa pipa2

	cat $FILE.in > pipa | ./$FILE.judge < pipa | tee pipa2 >> $FILE.tmp | ./$FILE < pipa2 | tee pipa >> $FILE.tmp

	rm pipa pipa2

	echo ""
	echo "============START INTERACTION============"
				cat $FILE.tmp | tee $FILE.out
				rm $FILE.tmp
	echo "=============END INTERACTION============="
	echo ""

			cat verdict
			rm verdict
}

normal(){
	satu
	#Compile the source code and show the stderr
	g++ $FILE.cpp -o $FILE -std=c++11
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
	g++ $FILE.cpp -o $FILE -std=c++11
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
	--compile-run) hanyaCompile
	;;
	-c) hanyaCompile
	;;
	--interactive) interaktif
	;;
	-i) interaktif
	;;
	--normal) normal
	;;
	-n) normal
	;;
	*) normal
	;;
esac

#Footer
echo ""
footer
# EOF
