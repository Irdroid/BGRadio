#!/bin/bash

##############################################################################
#									     # 
# BGR - Българско радио - Bash Плеър					     #
#									     #
# Автор  - Георги Бакалски, 2022г.					     #
# Лиценз - GNU General Public License 2.0				     #
# Версия - 0.1а								     #
#									     #
# Зависи от програмата ffplay от ffmpeg пакета				     #
# за Debian базирани дистрибуции sudo apt install ffmpeg		     #
#									     #
##############################################################################

clear

PLAYBACK=0

PS3="Избери Радио:"

STATIONS_LIST='Energy FM+ Nova Quit'
URL_LIST=''

##############################################################################
# Функцията "spinner" се използва за показване на прогрес, действие което се # 
# случва на заден фон.							     # 
##############################################################################

spinner () {
    local chars=('|' / - '\')

        # hide the cursor
            tput civis
            trap 'printf "\010"; tput cvvis; return' INT TERM

            printf %s "$*"

             while :; do
               for i in {0..3}; do
                  printf %s "${chars[i]}"
                  sleep 0.3
                  printf '\010'
               done
          done
 }

##############################################################################
# Тази фунция се ползва за получаването и изписване на екрана на името на    #
# текущата песен ( само за онлайн радио станциите които се поддържат )       #
##############################################################################

getsong () {
	ffprobe -hide_banner https://playerservices.streamtheworld.com/api/livestream-redirect/RADIO_ENERGYAAC_H.aac  |& grep  "StreamTitle"
 }

###############################################################################
# Избор на радиостанция от списък с налични				      #
###############################################################################

function Select()
{

select station in $STATIONS_LIST

	do

	  case $station in

		Energy)
			Play "Energy"
			break;; 
		FM+)
			Play "FM+"
			break;;
	 	Quit)
	 		exit;;
	  esac	

	  REPLY=""
	
	done

}

################################################################################
# Тази фунция се вика след направен избор на радиостанция и служи за свързване #
# и плейбек на избраната радиостанция от предишната функция		       #
################################################################################

function Play()
{
clear
printf  "\033[104mРадио: $1 \033[0m \n"
local pid return
# ffprobe -hide_banner https://playerservices.streamtheworld.com/api/livestream-redirect/RADIO_ENERGYAAC_H.aac  |& grep  "StreamTitle"
spinner 'Playing > ' & pid=$!
# ffprobe -hide_banner https://playerservices.streamtheworld.com/api/livestream-redirect/RADIO_ENERGYAAC_H.aac  |& grep  "StreamTitle"
#echo -e "\e[?16;0;200c"
echo "b - Back | q - Quit"
echo "" 
	while read -n 1 command;
 		do
			case $command in
				b)
					clear
					kill "$pid"
					wait "$pid"		
					echo "BGR - Българско радио - Bash player"
					echo;
					Select
					exit;;
				q)
					kill "$pid"
					wait "$pid"
					clear
					exit;;

				t)
					clear
					kill "$pid"
					wait "$pid"	
					getsong
					sleep 3
					Play
		
		
			esac

done
}

	echo "BGR - Българско радио - Bash player"
	echo;	
	Select		
