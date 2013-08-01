#!/bin/bash
#file: report_opt_simple.sh
#gathers information from documents produced in the course of litigation
#run in the top directory of the production
#use if the load file has the extension .opt 

#finds the load file, in this case the .opt file
opt_filepath=`find . -maxdepth 2 -type f | grep -i opt$` 

#return error if there's no OPT
if [[ ! -e $opt_filepath ]]; then
	echo "Oops! There doesn't appear to be an OPT file. Process terminated."
	exit
fi

#general information for the production report from user input
echo "What is the case name?"
read case_name
echo "Who did this production come from?"
read name
echo "When did you receive this production?"
read date_received
echo "What is the volume number? If it helps, the load file is `basename $opt_filepath`"
read volume_number

echo "Great! Thanks for the input.  Generating report..."
echo
echo 

#collects relevant information from the opt file
output=${volume_number}_report`date +%s`.txt #generates a unique file name
output_title=`date +%s` #generates a unique production report number
doc_prod=`grep ,Y, "$opt_filepath" | wc -l` #.opt files delineate document breaks with "Y"
page_prod_tif=`grep -i tif "$opt_filepath" | wc -l` #counts tif files produced
page_prod_jpg=`grep -i jpg "$opt_filepath" | wc -l` #counts jpg files produced
let "page_prod_total = $page_prod_tif + $page_prod_jpg" #combines tif and jpg count for total page count
bates_range=`head -n 1 "$opt_filepath" | sed 's/,.*.//'`-`tail -n 1 "$opt_filepath" | sed 's/,.*.//'` #finds the bates range
report_date=`date` #notes the date the report was created

#opens the output file for writing on FI 5
exec 5>~/lit_reports/$output

#main body of the report writing to FI 5
#title, bates range, production date, page count, document count, and report date
echo "$name Production Report $output_title" >&5
echo "Volume: $volume_number" >&5
echo "Bates Range: $bates_range" >&5
echo "Production Date: $date_received" >&5
echo "Documents Produced: $doc_prod" >&5 
echo "Pages Produced - Load File (tif): $page_prod_tif" >&5
echo "Pages Produced - Load File (jpg): $page_prod_jpg" >&5
echo "Total Pages Produced - Load File: $page_prod_total" >&5
echo "Report Date: $report_date"  >&5

#closes the output file from writing on FI 5
exec <&-

#shall we check the output? Yes, let's.
echo "***Start Production Report***"
echo

cat ~/lit_reports/$output

echo 
echo "***End Production Report***"
echo

exit
