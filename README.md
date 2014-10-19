## litrpt

A suite of shell scripts to used to track and evaluate document productions produced in the course of litigation.  When our office received a document production, typically attorneys would want to know how many documents were received, and what type of documents.  I created these scripts so attorneys could checkout what we received within a few minutes as opposed to waiting to get the documents processed and loaded into the database (Concordance, Relativity, etc.).

These were originally developed for use with bash, but I've also used them with cygwin.  Note some of the local file paths will need to be changed so the output files are saved in the right spot.

### Basic Report

The report_*.sh files check for total documents, total pages, and any native files that have been produced along with the tifs (.xls is the most common).  The output is a text file.

First, you'll want to check what load files have been provided with the production.  Typically you'll receive a .opt file and so you should run report_opt.sh.  If you receive and lfp load file, run report_lfp.sh.  Run the report script at the top level directory of the production.

### First Page Report

The report_firstpage_*.sh scripts copy the first page of each document (a .tif file) and put them in a folder of your choosing.  The first argument is the destination directory.

<pre><code>$ report_firstpage_opt.sh destination_directory</pre><code>

Again, you'll need to check what type of load file is provided.

Once all the tif's are assembled, I usually combine them into a pdf for easy viewing.  Now an attorney can have a high level view of the production, without loading it into the database.  
