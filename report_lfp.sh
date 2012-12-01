#!/bin/bash
#file:report_lfp.sh
#gathers information from documents produced in the course of litigation
#run in the top directory of the production
#use if the load file has the extension .lfp

#finds the load file, in this case the .lfp file
#generates a unique file name
#generates a unique production report number 
lfp_filepath="`find . | grep -i lfp$`"
output=`date +%s`_report.txt
output_title=`date +%s`

#general information for the production report from user input 
echo "What is the Lainer client number?"
read case_number
echo "Who did this production come from?"
read name
echo "When did you receive this production?"
read date_received

#opens the output file for writing on FI 5
exec 5>~/Desktop/$output

#main body of the report writing to FI 5
#title, bates range, production date, page count, and document count
echo "$name Production Report $output_title-$case_number" >&5
echo "Bates Range: `head -n 1 "$lfp_filepath" | cut -d ',' -f 2`-`tail -n 1 "$lfp_filepath" | cut -d ',' -f 2`" >&5
echo "Production Date: $date_received" >&5
echo "Documents Produced - D: " `grep ,D, "$lfp_filepath" | wc -l` >&5 #.lfp files deliniate document breaks with "D" or "C"
echo "Documents Produced - C: " `grep ,C, "$lfp_filepath" | wc -l` >&5 #.lfp files deliniate document breaks with "D" or "C"
echo "Pages Produced - Load File (.tif): " `grep -i tif "$lfp_filepath" | wc -l` >&5
echo "Pages Produced - Load File (.jpg): " `grep -i jpg "$lfp_filepath" | wc -l` >&5

#identifies and counts file extensions
while read line; do 
	echo ""$line" Files Produced - Directory: `find . | grep -w "$line" | wc -l`";
done <<< "`find . | rev | cut -d '.' -f 1 | rev | sort -u | sed 's/\/.*//g' | sed '/^$/d'`" >&5

#production size, directory structure, and report date
echo "Production Size & Directory Structure: " >&5
du -h . >&5
echo "Report Date: " `date` >&5

#closes the output file from writing on FI 5
exec <&-

cat ~/Desktop/$output

exit
