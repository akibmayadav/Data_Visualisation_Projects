library(plyr)
library(gdata)
library(data.table)
library(dplyr)

source("helper.R")
args = commandArgs(TRUE)
if (length(args) != 1)  {

    stop ("Please provide 1 argument;  directory of the state")
}



#open the base file present in args[1]/derived/mastersheet.csv -- give error if not found and stop
#open  myneta.csv files in args[1]/primary/myneta.csv -- give error if not found and stop
#get Unique year, ac number and ac name from the first.. same from the second..
#add sources to each of them ECI, MN respectively.


infile<-read.csv(paste0(args[1],"/derived/mastersheet.csv"),stringsAsFactors=FALSE)
myneta<-read.csv(paste0(args[1],"/primary/myneta/myneta.csv"),stringsAsFactors=FALSE)

infile<-unique(subset(infile,infile$Year>=2005,select=c("Year","AC_Name")))

myneta<-unique(subset(myneta,select=c("Year","conName")))

#First find those constituency names where there is exact match (modulo capital letters conversion)
myneta<-setnames(myneta,old=c("Year","conName"),new=c("Year","AC_Name"))

##convert ac_name to capital letters in infile and myneta frames
myneta$AC_Name<-canonicalizeACNames(myneta$AC_Name)
myneta$Year<-trimws(myneta$Year)
myneta$src<-"mn"

infile$AC_Name<-canonicalizeACNames(infile$AC_Name)
infile$Year<-trimws(infile$Year)
infile$src<-"ec"
#Now take an intersection of both frames to get what is common (in both A and B), A-B union B-A (on all columns except src)

common<-inner_join(myneta,infile,by=c("Year","AC_Name"))
##removing two extra columns added
common$src.x<-NULL
common$src.y<-NULL
                                        #Get the rest of the names where there is no match, we will need manual intervention in these cases
rest<-union(anti_join(myneta,infile,by=c("Year","AC_Name")),
            anti_join(infile,myneta,by=c("Year","AC_Name")))


#store common in a common file in the format year, ec_AC_Name, mn_AC_Name, for this drop src and create anotehr column after copying AC_Name
#and rename it to mn_AC_Name. Rename the earlier AC_Name column to ec_AC_Name
common$src<-NULL
common<-unique(common)
common$mn_AC_Name<-common$AC_Name
common$ec_AC_Name<-common$AC_Name
common$AC_Name<-NULL
write.csv(common,paste0(args[1],"/primary/myneta/common_acname_keys.csv"),row.names=FALSE)
#store rest of the data in another file that needs to be worked upon manually to create a csv file with headers year, ec_AC_Name, mn_AC_Name
rest<-arrange(rest,Year,AC_Name)

write.csv(rest,paste0(args[1],"/primary/myneta/manual_acname_keys.csv"),row.names=FALSE)
