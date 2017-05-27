#!/bin/bash
#
# Created by Muhammad Faishol Amirul Mukminin on 17/05/17 07:32 PM
# Copyright (c) 2017. All rights reserved.
#
# Last modified 24/05/17 12:33 AM
#
usage(){
	echo "Usage: febug <SOURCE CODE> [MODE]"
	echo ""
	echo "[MODE]"
	echo "  -c                compile and run only. Input using STDIN."
	echo "  -i<x>   Output format:"
	echo "      -i            interactive mode with default judger."
	echo "      -i=<FILE>     interactive mode with custom judger."
	echo ""
	echo "  -n<x>   Output format:"
	echo "      -n            normal mode. Input using FILE."
	echo "      -n=<FILE>     normal mode. Input using custom FILE."
	echo "      -n=<FOLDER>   normal mode. Input using all files in FOLDER."
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
	if [[ $file == *".cpp" || $file == *".c" ]]
	then
		if [[ $file == *".cpp" ]]; then
				file=${file/.cpp/}
				stt=$( g++ $file.cpp -o $file -std=c++11 -O2 2>&1 | tee _STT_ )
		else
				file=${file/.c/}
				stt=$( g++ $file.c -o $file -std=c++11 -O2 2>&1 | tee _STT_ )
		fi

		cat _STT_
		rm _STT_
		if [[ $stt == *"error:"* ]]; then
			echo ""
			echo "[ERROR] Compilation Error"
			footer
			exit 0
		fi

	elif [[ $file == *".pas" ]]
	then
		file=${file/.pas/}
		stt=$( fpc $file.pas -o $file -O2 2>&1 | tee _STT_ )

		cat _STT_
		rm _STT_

		if [[ $stt == *"error exitcode"* ]]; then
			echo ""
			echo "[ERROR] Compilation Error"
			footer
			exit 0
		fi

	else
		clear
		echo "[ERROR] Invalid source code"
		footer
		exit 0
	fi

	if [ "$mode" == '-i' ]
	then
			if [[ $judge == *".cpp" || $judge == *".c" ]]
			then
				if [[ $judge == *".cpp" ]]; then
						judge=${judge/.cpp/}
						stt=$( g++ $judge.cpp -o $judge -std=c++11 -O2 2>&1 | tee _STT_ )
				else
						judge=${judge/.c/}
						stt=$( g++ $judge.c -o $judge -std=c++11 -O2 2>&1 | tee _STT_ )
				fi

				cat _STT_
				rm _STT_

				if [[ $stt == *"error"* ]]; then
					echo ""
					echo "[ERROR] Compilation Error"
					footer
					exit 0
				fi

			elif [[ $judge == *".pas" ]]
			then
				judge=${judge/.pas/}
				stt=$( fpc $judge.pas -o $judge -O2 2>&1 | tee _STT_ )

				cat _STT_
				rm _STT_

				if [[ $stt == *"error exitcode"* ]]; then
					echo ""
					echo "[ERROR] Compilation Error"
					footer
					exit 0
				fi
			else
				clear
				echo "[ERROR] Invalid source code"
				footer
				exit 0
			fi
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

		stt=$( file $file.in )
		if [[ $stt == *"cannot"* ]]; then
			echo "[ERROR] Missing or invalid input file"
			footer
			exit 0
		fi

		mkfifo pipa1 pipa2
		cat $file.in > pipa1 | ./$judge < pipa1 | tee pipa2 >> $file.tmp | ./$file < pipa2 | tee pipa1 >> $file.tmp
		rm pipa1 pipa2

		echo "============START INTERACTION============"
				cat $file.tmp | tee $file.out
				rm $file.tmp
		echo "=============END INTERACTION============="

		echo ""
			cat verdict
			rm verdict

	else
		stt=$( file $file.in )
		if [[ $stt == *"cannot"* ]]; then
			echo "[ERROR] Missing or invalid input file"
			footer
			exit 0
		fi

		if [ "$n_args" == 'file' ]; then
			#If file
			{ time ./$file < $inp_file > $out_file ; } 2> waktu

			echo "============START OUTPUT============"
						cat $out_file
			echo "=============END OUTPUT============="

			echo "================"
			echo "| RUNNING TIME |"
			echo "================"
				#Show command running time
				cat waktu
				rm waktu
		else
			ls $path > _FBG_

			while read -r inp
			do
				stt=$( file $path/$inp )

				if [[ $stt == *"ASCII text"* ]]; then
					out=${inp/.in/.out}
					out=${out/.txt/.out}

					if [[ $inp == *".in" || $inp == *".txt" ]]; then
						echo "Processing "$path/$inp

						./$file < $path/$inp > $path/$out

						echo "Finished with output "$path/$out
					fi
				fi
			done < _FBG_

			rm _FBG_
		fi

	fi
	echo ""
	echo "Your program running successfully"
}

footer(){
	echo ""
	echo ""
	echo "                    FeBug version 1.3.2"
	echo "       Developed by Muhammad Faishol Amirul Mukminin"
}

# MAIN PROGRAM
	file=$1

	mode=$2
	judge=${file/./.judge.}

	n_args=file

	path=

	inp_file=${file/.cpp/.in}
	inp_file=${inp_file/.c/.in}
	inp_file=${inp_file/.pas/.in}

	out_file=${inp_file/.in/.out}

	if [ $# -lt 1 ]; then
		usage
	fi

	if (( $# == 2 )); then
		if [[ $mode != "-i"* && $mode != "-n"* && "$2" != '-c' ]]; then
			echo "[ERROR] Invalid mode"
			footer
			exit 0
		else
			if [[ $mode == "-i="* ]]
			then
				judge=${mode/-i=/}
				mode=-i
			elif [[ $mode == "-n="* ]]
			then
				n_args=${mode/-n=/}
				stt=$( file $n_args )

				if [[ $stt == *"cannot"* ]]; then
					echo "[ERROR] "$stt
					footer
					exit 0
				elif [[ $stt == *"directory"* ]]; then
					path=$n_args
					n_args=folder

				elif [[ $n_args == *".in" || $n_args == *".txt" ]]; then
					inp_file=$n_args

					out_file=${inp_file/.in/.out}
					out_file=${out_file/.txt/.out}

					n_args=file
				fi

				mode=-n
			fi
		fi
	fi

	clear
	compile
	run_program
	footer

#END MAIN PROGRAM
