#!/bin/bash
#file: report_opt.sh
#gathers information from documents produced in the course of litigation
#run in the top directory of the production
#use if the load file has the extension .opt

#finds the load file, in this case the .opt file
#generates a unique file name
#generates a unique production report number 

opt_filepath=`find . -maxdepth 3 -type f | grep -i opt$`
output=`date +%s`_report.txt
output_title=`date +%s`

#general information for the production report from user input
echo "What is the Lainer client number?"
read case_number
echo "Who did this production come from?"
read name
echo "When did you receive this production?"
read date_received

echo "Great! Thanks for the input.  Generating report..." 

#opens the output file for writing on FI 5
exec 5>~/Desktop/$output

#main body of the report writing to FI 5
#title, bates range, production date, page count, and document count
echo "$name Production Report $output_title-$case_number" >&5
echo "Bates Range: `head -n 1 "$opt_filepath" | sed 's/,.*.//'`-`tail -n 1 "$opt_filepath" | sed 's/,.*.//'`" >&5
echo "Production Date: $date_received" >&5
echo "Documents Produced: " `grep ,Y, "$opt_filepath" | wc -l` >&5 #.opt files delineate document breaks with "Y"
echo "Pages Produced - Load File (.tif): " `grep -i tif "$opt_filepath" | wc -l` >&5
echo "Pages Produced - Load File (.jpg): " `grep -i jpg "$opt_filepath" | wc -l` >&5

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
