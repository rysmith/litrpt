#!/bin/bash
#file:report_firstpage_lfp.sh
#finds the first page for each of the produced documents and copies them to a given directory ($1)
#combine the first pages into a PDF to create the first page report.
#load file should be in .lfp format

mkdir $1;

#finds the load file, in this case the .lfp file
lfp_filepath="`find . | grep -i lfp$`"

#general information for the cover page from user input 
echo "Who did this production come from?"
read name
echo "What is the Lanier case number (and case name)?"
read case_number
echo "When was this production received?"
read date_received

#opens the cover page file for writing on FI 5
exec 5>$1/1coverpage.txt

#cover page information writing to FI 5
#title, case number, bates range, document count, and production date
echo "$name First Page Report" >&5
echo "Case Number: $case_number" >&5
echo "Bates Range: `head -n 1 "$lfp_filepath" | cut -d ',' -f 2`-`tail -n 1 "$lfp_filepath" | cut -d ',' -f 2`" >&5
echo "Number of Documents Produced: " `grep ,D, "$lfp_filepath" | wc -l` >&5 #.lfp files deliniate document breaks with "D"
echo "Date Received: $date_received" >&5
echo "Please email rps@lanierlawfirm.com if you have any questions." >&5

#closes the cover page file from writing on FI 5
exec <&-

#identifies the first page of each document
grep ,D, "$lfp_filepath" > $1/temp1.txt;
cat $1/temp1.txt;

#isolates the location of each first page
#check load file for correct cut fields and delimiters
#directory paths in the load file vary from production to production.
cut -d ':' -f 2 $1/temp1.txt | cut -d ',' -f 3 | sed 's/\\/\//g' >> $1/temp2.txt
cat $1/temp2.txt

#copies the first pages to given directory ($1)
#check directory structure for correct cp path
#directory paths in the load file vary from production to production.
while read line; do 
	cp -iv "`pwd`/$line" $1; 
done < $1/temp2.txt;

rm $1/temp1.txt $1/temp2.txt

exit