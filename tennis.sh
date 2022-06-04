#!/bin/bash
#Ben Levi 318811304


score1=50
score2=50
player_1_guess=0
player_2_guess=0
board=0
shouldStop=0


firstPartBoard() {
	showScore
	echo " --------------------------------- "
	echo " |       |       #       |       | "
	echo " |       |       #       |       | "
}

secondPartStartBoard() {
	echo " |       |       #       |       | "
	echo " |       |       #       |       | "
	echo " --------------------------------- "
}

secondPartBoard() {
	secondPartStartBoard
	showGuess
}

showScore() {
	echo " Player 1: ${score1}         Player 2: ${score2} "
}

showGuess() {
	echo -e "       Player 1 played: ${player_1_guess}\n       Player 2 played: ${player_2_guess}\n\n"
}

startBoard() {
	firstPartBoard
	echo " |       |       O       |       | "
	secondPartStartBoard
}


printBoard() {
	firstPartBoard
	case $board in

	  -3)
	    echo "O|       |       #       |       | "
	    ;;

	  -2)
	    echo " |   O   |       #       |       | "
	    ;;

	  -1)
	    echo " |       |   O   #       |       | "
	    ;;

	  3)
	    echo " |       |       #       |       |O"
	    ;;

	  2)
	    echo " |       |       #       |   O   | "
	    ;;

	  1)
	    echo " |       |       #   O   |       | "
	    ;;

	  0)
	    echo " |       |       O       |       | "
	    ;;

	esac
	secondPartBoard
}


takeGuess1() {
	echo "PLAYER 1 PICK A NUMBER: "
	read -s player_1_guess
	if ! [[ $player_1_guess =~ ^[0-9]+$ ]]
	then
		echo "NOT A VALID MOVE !"
		takeGuess1
	fi
	if [[ $player_1_guess -gt $score1 ]] || [[ 0 -gt $player_1_guess ]]
	then
		echo "NOT A VALID MOVE !"
		takeGuess1
	fi
}

takeGuess2() {
	echo "PLAYER 2 PICK A NUMBER: "
	read -s player_2_guess
	if ! [[ $player_2_guess =~ ^[0-9]+$ ]]
	then
		echo "NOT A VALID MOVE !"
		takeGuess2
	fi
	if [[ $player_2_guess -gt $score2 ]] || [[ 0 -gt $player_2_guess ]]
	then
		echo "NOT A VALID MOVE !"
		takeGuess2
	fi
}

takeGuess() {
	takeGuess1
	score1=$[$score1 - $player_1_guess]
	takeGuess2
	score2=$[$score2 - $player_2_guess]
}

updateBoard() {
	add=0
	if [[ $player_1_guess -gt $player_2_guess ]]; then
		add=1
	elif [[ $player_2_guess -gt $player_1_guess ]]; then
		add=-1
	fi
	board=$[$board + $add]
	if [[ 0 -eq board ]]; then
		board=$[$board + $add]
	fi
	printBoard
}

checkWin() {
	if [[ $board -eq 3 ]]; then
		echo "PLAYER 1 WINS !"
		shouldStop=1
	elif [[ $board -eq -3 ]]; then
		echo "PLAYER 2 WINS !"
		shouldStop=1
	elif [[ $score1 -eq 0 ]] && [[ $score2 -ne 0 ]]
	then
		echo "PLAYER 2 WINS !"
		shouldStop=1
	elif [[ $score1 -ne 0 ]] && [[ $score2 -eq 0 ]]
	then
		echo "PLAYER 1 WINS !"
		shouldStop=1
	elif [[ $score1 -eq 0 ]] && [[ $score2 -eq 0 ]]
	then
		if [[ $board -gt 0 ]]; then
			echo "PLAYER 1 WINS !"
		elif [[ 0 -gt $board ]]; then
			echo "PLAYER 2 WINS !"
		elif [[ 0 -eq $board ]]; then
			echo "IT'S A DRAW !"
		fi
		shouldStop=1
	fi
}

startBoard
while [[ $shouldStop -eq 0 ]]; do
	takeGuess
	updateBoard
	checkWin
done