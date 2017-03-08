suppressWarnings(suppressMessages(library(plyr)))
suppressWarnings(suppressMessages(library(gdata)))
suppressWarnings(suppressMessages(library(data.table)))
suppressWarnings(suppressMessages(library(plyr)))
source("helper.R")
args = commandArgs(TRUE)
if (length(args) != 3)  {

    stop ("Please provide 3 arguments:  Root directory of the  state name, the path to Vidhan Sabha number file and the path to
          delimitation info file")
}

sano<-read.csv(args[2],stringsAsFactors=FALSE)
deliminfo<-read.csv(args[3],stringsAsFactors=FALSE)

addVidhanSabhaNumber<- function(ms_eci){
                                        #    print('entering')
    ms_eci$key_year<-ms_eci$Year

    ms_eci$state<-trimws(ms_eci$State_name)
                                        #print('done')
    ms_eci$Year<-NULL
    ms_eci$State_name<-NULL
    
    sano$state<-trimws(sano$state)
                                        #print('done')
    ## a<-(unique(subset(ms_eci,select=c("state","key_year"))))
    ## b<-(unique(subset(sano,sano$state=="Uttar_Pradesh",select=c("state","key_year"))))
    ## library(dplyr)
    ## print(anti_join(a,b))
    ## print(anti_join(b,a))
    t<-merge(ms_eci,sano,by.x=c("state","key_year"),by.y=c("state","key_year"))
                                        #print('done')
    if(nrow(t)!=nrow(ms_eci)){
        print(unique(ms_eci$key_year))
        print(unique(sano$key_year))
       stop('Some serious error as for some years we do not have state assembly number in Vidhansabha.csv')
 
    }
    t$key_year<-NULL
    setnames(t,old=c("year","state"),new=c("Year","State_name"))
    return(t)
    
    }


addDelimID <- function(ms_eci){
   #########################################################
    ##Now merge delimitation id with this information, What if an election took place over two years? no delim changed happened in those cases,
    ##so no issue but it is a system specific invariant
    t<-merge(ms_eci,deliminfo,by.x=c("Year"),by.y=c("Year"))
    return(t)
    ##########################################################    
 
    }

DerivedVarAdd<-function(basepathcand,basepathelector,basepath){

    ms_eci <- read.csv(basepathcand,stringsAsFactors=FALSE)
    ms_eci$Party<-enc2utf8(ms_eci$Party)
    # split - Splitting the column name by the delimtter - 
    #ms_eci$State <- trimws(lapply(strsplit(as.character(ms_eci$conName), "\\-"), "[", 1))
    #ms_eci$conName <- trimws(lapply(strsplit(as.character(ms_eci$conName), "\\-"), "[", 2))
    #print(nrow(ms_eci))
    #all aggregation need to be done based on sa_no and AC_no..instead of year and AC_no
    ms_eci<-addVidhanSabhaNumber(ms_eci)
    ms_eci<-addDelimID(ms_eci)
    # valid_votes
    valid_votes <- aggregate(ms_eci$Votes, by=list(sa_no=ms_eci$sa_no,AC_no=ms_eci$AC_no), FUN=sum)
    names(valid_votes)[names(valid_votes) == 'x'] <- 'Valid_Votes'
    ms_eci = merge(ms_eci, valid_votes, by.x=c("sa_no","AC_no"), by.y=c("sa_no","AC_no"), all.x = TRUE)
    #print(nrow(ms_eci))
   # electors
    print(paste('reading',basepathelector))
    elector <- read.csv(basepathelector,stringsAsFactors=FALSE)
    #also add vidhansabha number here so that merging happens w.r.t. sa_no and AC_no
    elector<-addVidhanSabhaNumber(elector)
   total_electors  <- subset(elector, select = c("sa_no","AC_no", "Electors","AC_name","AC_type"))
   ms_eci = merge(ms_eci, total_electors, by.x=c("sa_no","AC_no"), by.y=c("sa_no","AC_no"))
    #print(nrow(ms_eci))
    #View(ms_eci)
   # N_cand
    ms_eci$Cand<-trimws(enc2utf8(ms_eci$Cand))
    ms_eci <- ddply(ms_eci,.(sa_no,AC_no),transform, N_cand = ifelse("none of the above" %in% tolower(Cand), length(Cand)-1,length(Cand)))
   # ms_eci <- ddply(ms_eci,.(Year,AC_no),transform, N_cand = length(Cand))

   # Position 
   #ms_eci <- transform(ms_eci, position = ave(Votes, Year, AC_no, FUN = function(x) rank(-x, ties.method = "first")))
    #print(nrow(ms_eci))
   # turnout, Q?: Why didnt we use voters instead of valid_votes. Ans: Because for example in Keral 2011,16 we didnt have that infor
    #hopefully that wont affect percentage that much
    ms_eci$turnout <- round(ms_eci$Valid_Votes*100/ms_eci$Electors, digits = 2) 

  # percent
  ms_eci$percent <- round(ms_eci$Votes*100/ms_eci$Valid_Votes, digits = 2) 
    #print(nrow(ms_eci))
  #deposit lost[if vote share is less than 1/6]
  ms_eci$Deposit_Lost<-"no"
  ms_eci$Deposit_Lost[ms_eci$percent<=.16]<-"yes"

  #margin addition
  ms_eci$newone<-(as.numeric(ms_eci$Position)+1)

  cp<-subset(ms_eci,select=c("sa_no","AC_no","Position","Votes"))
  names(cp)[4]<-"OtherVotes"
  #View(ms_eci)
    #print(nrow(ms_eci))
  d<-merge(ms_eci,cp,by.x=c("sa_no","AC_no","newone"),by.y=c("sa_no","AC_no","Position"),all.x=TRUE)
  #View(ms_eci)
    #print(nrow(ms_eci))
  d$Margin[!is.na(d$OtherVotes)]<-d$Votes[!is.na(d$OtherVotes)]-d$OtherVotes[!is.na(d$OtherVotes)]
  d$Margin[is.na(d$OtherVotes)]<-0
  e<-subset(d,select=-c(newone,OtherVotes))
  ms_eci<-arrange(e,sa_no,AC_no,Position)

  ms_eci$Margin_Percent<-(round(ms_eci$Margin/ms_eci$Valid_Votes,digits=4))*100
  ms_eci<-unique(ms_eci)
  # set names
setnames(ms_eci, old=c("AC_no","sa_no","Votes","Cand","Sex","AC_name","AC_type","Party","State_name","Valid_Votes","Electors","N_cand", "Position", "turnout", "percent"), new=c("AC_No","sa_no", "Votes1", "Cand1", "Sex1", "AC_Name","AC_Type", "Party1", "State_Name", "Valid_Votes", "Electors", "N_Cand","Position", "Turnout", "Vote_Sh"))

      ## bp<-paste(basepath,"derived/derived.csv",sep="/") 

#print(names(ms_eci))
    ms_eci<-subset(ms_eci,select=c("State_Name","Year","month","sa_no","DelimID","AC_No","Cand1","Sex1","Party1","Votes1","Age","Caste","Valid_Votes","Electors","AC_Name","AC_Type","N_Cand","Position","Turnout","Vote_Sh","Deposit_Lost","Margin","Margin_Percent"))

      ms_eci<-arrange(ms_eci,sa_no,State_Name)


#write.csv(ms_eci,bp,row.names=FALSE)
return(ms_eci)
    
  }

##Code to merge caste info file, casteinfopath- path to the caste info file, derived- variable that contains the merged file so far
##The order of invocation should be.. DerivedVarAdd->either of these two functions(combineCasteData/combineRegionData).

combineCasteData<-function(casteinfopath,derived){
    #load combine cast csv file
    combinecast <- read.csv(casteinfopath,stringsAsFactors=FALSE)
    #add Vidhansabha number here as well and then 
    #merge both files based on statename, sa_no, ac number and position
    combinecast<-addVidhanSabhaNumber(combinecast)
    combinecast<-subset(combinecast,select=c("sa_no","State_name","AC_no","Position","Jati","Caste_Rec","Rel","New.Caste","Old_Jati"))
    d<-merge(derived,combinecast,by.x=c("sa_no","State_Name","AC_No","Position"),by.y=c("sa_no","State_name","AC_no","Position"),all.x=T)
    #write the file back to derived.csv
    ## print(nrow(d))
    ## write.csv(d,paste(basepath,"mastersheet.csv",sep="/"),row.names=FALSE)
    return(d)
    }

##Code to merge region info file

combineRegionData<-function(regioninfopath,derived){

    #load combined region csv file
    combineregion <- read.csv(regioninfopath,stringsAsFactors=FALSE)

    #load derived.csv
    ## derived <- read.csv(paste(basepath,"mastersheet.csv",sep="/"),stringsAsFactors=FALSE)
    ## print(nrow(derived))
    #merge both files based on State and Delimitation ID
    combineregion<-subset(combineregion,select=c("State_name","AC_no","District_Name","Sub_Region","DelimID"))
    d<-merge(derived,combineregion,by.x=c("State_Name","AC_No","DelimID"),by.y=c("State_name","AC_no","DelimID"),all.x=T)
#    print(names(d))
    #wirte the file back to derived.csv
    #first put columns properly
  d<-subset(d,select=c("State_Name","Year","month","sa_no","DelimID","AC_No","Position","Cand1","Sex1","Party1","Votes1","Age","Caste","Valid_Votes","Electors","AC_Name","AC_Type","District_Name","Sub_Region","N_Cand","Turnout","Vote_Sh","Deposit_Lost","Margin","Margin_Percent","Jati","Caste_Rec","Rel","New.Caste","Old_Jati"))
    d<-arrange(d,State_Name,sa_no,AC_No)
    return(d)
 
  }



##############Extract data from xls files present in the second argument as subdirectory...
    basepath<-paste(args[1],"",sep="/")
    basepathcand<-paste(basepath,"primary/candidates_electoral_info.csv",sep="/")
    basepathelector<-paste(basepath,"primary/constituency_electoral_info.csv",sep="/")
    print(basepath)
    added<-DerivedVarAdd(basepathcand,basepathelector,basepath)
    #now merge caste files and region files information
    basepathcaste<- paste(basepath,"primary/candidates_caste_info.csv",sep="/")  
    basepathregion<- paste(basepath,"primary/constituency_region_info.csv",sep="/")  
    castecombined<-combineCasteData(basepathcaste,added)
    casteregioncombined<-combineRegionData(basepathregion,castecombined)
    write.csv(casteregioncombined,paste(basepath,"derived/mastersheet.csv",sep="/"),row.names=FALSE)
