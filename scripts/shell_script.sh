#!/bin/bash

##########################################################
# SET DEFAUL VARIABLES

filenametime=$(date +"%m%d%Y%H%M%S")

#########################################################
# SET VARIABLES 
dir_path=$(cd "$(dirname "${BASH_SOURCE:-$0}")" && pwd)
export BASE_FOLDER='/home/stan/wcd/lab1/'
export SCRIPTS_FOLDER=$dir_path
export INPUT_FOLDER='/home/stan/wcd/lab1/input'
export OUT_FOLDER='/home/stan/wcd/lab1/output'
export LOGDIR='/home/stan/wcd/lab1/logs'
export SHELL_SCRIPT_NAME='shell_script'
export LOG_FILE=${LOGDIR}/${SHELL_SCRIPT_NAME}_${filenametime}.log
#########################################################

# SET LOG RULES

exec > >(tee ${LOG_FILE}) 2>&1

#########################################################
# PART 5: DOWNLOAD DATA
echo "Start download data"

for year in {2020..2022}; # or use (seq 2019 2022)
do wget -N --content-disposition "https://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID=48549&Year=${year}&Month=2&Day=14&timeframe=1&submit= Download+Data" -O ${INPUT_FOLDER}/${year}.csv;
done;

RC1=$?
if [ ${RC1} != 0 ]; then
	echo "DOWNLOAD DATA FAILED"
	echo "[ERROR:] RETURN CODE:  ${RC1}"
	echo "[ERROR:] REFER TO THE LOG FOR THE REASON FOR THE FAILURE."
	exit 1
fi
###${RC1} = 0 means sucessful running the script
#########################################################
# PART 5: RUN PYTHON
echo "Start to run Python Script"
python3 ${SCRIPTS_FOLDER}/python_script.py


RC1=$?
if [ ${RC1} != 0 ]; then
	echo "PYTHON RUNNING FAILED"
	echo "[ERROR:] RETURN CODE:  ${RC1}"
	echo "[ERROR:] REFER TO THE LOG FOR THE REASON FOR THE FAILURE."
	exit 1
fi

echo "PROGRAM SUCCEEDED"

exit 0 