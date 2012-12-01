#!/bin/bash
#file:report_firsttext.sh
#gathers the first 8 line of text from each document from a particular production
#should be run in the top level directory of the production
#if no text is yielded try converting the .txt files to utf8

echo "Who did this production come from?"
read name
echo "What is the Lanier case number (and case name)?"
read case_number
echo "When was this production received?"
read date_received

#opens the temp file for writing on FI 5
exec 5>~/Desktop/text_temp.txt

#general information for the header from user input 
echo "------------------------------------------------------------------------------------------------------------------------------" >&5;
echo "$name Production Snippets" >&5;
echo "Case Number: $case_number" >&5;
echo "Date Received: $date_received" >&5;
echo "Please email rps@lanierlawfirm.com if you have any questions." >&5;
echo "------------------------------------------------------------------------------------------------------------------------------" >&5;

#check the case of the file extension
for f in `find . | grep -i txt$`; do
    echo "`basename "$f" .txt`:" >&5;
    head -n 8 "$f" >&5;
    echo "------------------------------------------------------------------------------------------------------------------------------" >&5;
done

#closes the temp file from writing on FI 5
exec <&-

# delete leading whitespace (spaces, tabs) from front of each line
# aligns all text flush left
awk '{sub(/^[ \t]+/,"")};1' ~/Desktop/text_temp.txt > $1

rm ~/Desktop/text_temp.txt

cat $1

exit
