#!/bin/bash

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

compile(){
	echo "================"
	echo "| Compiling... |"
	echo "================"

	#Get code language from file extention
	if [[ $file == *".cpp" ]]
	then
		file=${file/.cpp/}
		g++ $file.cpp -o $file -std=c++11

		if [ "$mode" == '-i' ]
		then
			g++ $file.judge.cpp -o $file.judge -std=c++11
		fi

	elif [[ $file == *".c" ]]
	then
		file=${file/.c/}
		g++ $file.c -o $file -std=c++11

		if [ "$mode" == '-i' ]
		then
			g++ $file.judge.c -o $file.judge -std=c++11
		fi

	elif [[ $file == *".pas" ]]
	then
		file=${file/.pas/}
		fpc $file.pas -o $file

		if [ "$mode" == '-i' ]
		then
			fpc $file.judge.pas -o $file.judge
		fi

	else
		clear
		echo "Bahasa belum didukung"
		footer
		exit 0
	fi

	echo "================"
	echo "| Compile Done |"
	echo "================"
}

run_program(){
	echo "==================="
	echo "| RUNNING PROGRAM |"
	echo "==================="

	if [ "$mode" == '-c' ]; then
		echo "============START PROGRAM============"
			./$file
		echo "=============END PROGRAM============="

	elif [ "$mode" == '-i' ]; then
		mkfifo pipa pipa2
		cat $file.in > pipa | ./$file.judge < pipa | tee pipa2 >> $file.tmp | ./$file < pipa2 | tee pipa >> $file.tmp
		rm pipa pipa2

		echo "============START INTERACTION============"
				cat $file.tmp | tee $file.out
				rm $file.tmp
		echo "=============END INTERACTION============="

		echo ""
			cat verdict
			rm verdict

	else
		echo "lljjll"
		{ time ./$file < $file.in > $file.out ; } 2> waktu

		echo "============START OUTPUT============"
					cat $file.out
		echo "=============END OUTPUT============="

		echo "================"
		echo "| RUNNING TIME |"
		echo "================"
			#Show command running time
			cat waktu
			rm waktu

	fi

}

footer(){
	echo ""
	echo ""
	echo "			     FeBug version 1.2.1"
	echo "		Developed by Muhammad Faishol Amirul Mukminin"
}

# MAIN PROGRAM
	file=$1
	mode=$2

	if [ $# -lt 1 ]; then
		usage
	fi

	if (( $# == 2 )); then
		if [[ "$2" != '-i' && "$2" != '-n' && "$2" != '-c' ]]; then
			echo "Invalid mode"
			exit 0
		fi
	fi

	clear
	compile
	run_program
	footer

#END MAIN PROGRAM
