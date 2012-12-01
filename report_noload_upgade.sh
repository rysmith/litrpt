#!/bin/bash
#file:report_noload.sh
#gathers information from documents produced in the course of litigation
#run in the top directory of the production
#use if no load file was provided

#generates a unique file name
#generates a unique production report number
output=`date +%s`_report.txt
output_title=`date +%s`

#general information for the production report from user input 
echo "What is the Lainer client number?"
read case_number
echo "Who did this production come from?"
read name
echo "When did you receive this production?"
read date_received
echo "What is the bates range?"
read bates_range

#opens the output file for writing on FI 5
exec 5>~/Desktop/$output

#main body of the report writing to FI 5
#title, bates range, and production date
echo "$name Production Report $output_title-$case_number" >&5
echo "Bates Range: $bates_range" >&5
echo "Production Date: $date_received" >&5

#identifies and counts file extensions
while read line; do 
	echo "${line##*.}" | tr '[A-Z]' '[a-z]'"
done <<< "`find . -type f`"

#checks DAT metadata headers


#production size, directory structure, and report date
echo "Production Size & Directory Structure: " >&5
du -h . >&5
echo "Report Date: " `date` >&5

#closes the output file from writing on FI 5
exec <&-

cat ~/Desktop/$output

exit

