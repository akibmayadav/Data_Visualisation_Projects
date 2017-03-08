suppressWarnings(suppressMessages(library(plyr)))
suppressWarnings(suppressMessages(library(gdata)))
suppressWarnings(suppressMessages(library(data.table)))
suppressWarnings(suppressMessages(library(plyr)))

args = commandArgs(TRUE)
if (length(args) != 1)  {

    stop ("Please provide 1 argument:  Root directory containing the primary and derived folders")
}

CreateDirIfAbsent<-function(path){
    #check if a directory exist , if not then create it
    res<-dir.exists(path)
    if(!res){
        dir.create(file.path(path),recursive=TRUE)
    }
}


#stname is not used for GE election as derived.csv contains data about all states all general elections
GenLokDhabaFiles<-function(GE_mastersheet,lokdhabapath){
      #For time being assume that file is alwasy named as derived.csv inside basepath
      



GE_timeline_general <- data.frame( Year=character(),ga_no=integer(), month=integer(),
               "Parties contested"=integer(),
               "Parties represented"=integer(),
               "Total Candidates"=integer(),
               "Women percentage"=integer(),
               "Deposit Saved"=integer(), check.names=F)

GE_maps_general <- data.frame()
#Rolling it over all states in the mastersheet
#for(statename in unique(GE_mastersheet$State_Name))
    {
        # Rolling it over the years in the mastersheet
        for (gano in unique(GE_mastersheet$ga_no)){
            if(is.na(gano))
                next
                                        # Set the common values 
                                        #statename <- as.character(state_mastersheet$State_Name[1])
                                        # To get the total number of parties contesting and parties represented in every assembly
            mastersheet_year <- GE_mastersheet[GE_mastersheet$ga_no== gano,]
            parties_contested <- length(unique(mastersheet_year[,c("Party1")]))
            mastersheet_year_winners <- mastersheet_year[mastersheet_year$Position == 1,]
            parties_represented <- length(unique(mastersheet_year_winners[,c("Party1")]))
  
                                        # To get the number of candidates contested and the no of candidates who lost their deposit
            candidates_contesting_elections <- nrow(mastersheet_year[mastersheet_year$Cand1 != "None of the Above",])
            candidates_lost_deposit_ld <-
        nrow(mastersheet_year[tolower(mastersheet_year$Cand1) != "none of the above" & mastersheet_year$Deposit_Lost == 'no',])

                                        # To get the women winners percentage
            women_winners_percentage <-
                round(nrow(mastersheet_year_winners[tolower(mastersheet_year_winners$Sex1) == "f",])*100/nrow(mastersheet_year_winners), digits = 2)

                                        # rbind states that merging objects demands matching names:
            #print(statename)
            year=mastersheet_year$Year[1]##we need some year to fill in , even if one ga_no is split over two years we pick the first one
            monthno=mastersheet_year$month[1]
            GE_timeline_general <- rbind(GE_timeline_general,
          data.frame( Year = as.character(year),ga_no=gano, month=monthno,
                     "Parties contested" = parties_contested,
                     "Parties represented" = parties_represented,
                     "Total Candidates" = candidates_contesting_elections,
                     "Deposit Saved" = candidates_lost_deposit_ld,
                     "Women percentage" = women_winners_percentage,
                     check.names=F))
  
#print(nrow(AE_state_timeline_general))
# To get the general values for the maps
    AE_state_main <-
    subset(mastersheet_year, Position == 1,
           select = c(State_Name,Year,ga_no,month,PC_No, PC_Name, Turnout,Vote_Sh,PC_Type, Electors,  Margin, N_Cand, Position, Sex1, Party1, Votes1, Cand1, Rel, Margin_Percent))
    #AE_state_main$Turnout <- as.numeric(AE_state_main$Voters)*100/as.numeric(AE_state_main$Electors)
    AE_state_main$Margin_percent <- AE_state_main$Margin_Percent
    AE_state_main$Vote_percent <- AE_state_main$Vote_Sh
    AE_state_main$Year <- year
  
  if (2 %in% mastersheet_year$Position){
    AE_state_Runner <- subset(mastersheet_year, Position == 2, select = c(State_Name,PC_No,  Sex1, Party1, Votes1, Cand1, Rel,Vote_Sh))
    AE_state_Runner$Vote_percent <- AE_state_Runner$Vote_Sh
    AE_state_Runner <- subset(AE_state_Runner, select = c(State_Name,PC_No, Cand1, Party1, Sex1))
    AE_state_Runner <- setNames(AE_state_Runner, c("State_Name","PC_No","Runner","Runner_party", "Runner_sex"))
    AE_state_main <- merge(AE_state_main, AE_state_Runner, by=c("State_Name","PC_No"),all.x=T)
  }else {
    AE_state_main$Runner <- NA
    AE_state_main$Runner_party <- NA
    AE_state_main$Runner_sex <- NA
  }
  
  if ('none of the above' %in% tolower(mastersheet_year$Cand1)){
    AE_state_NOTA <- subset(mastersheet_year, tolower(Cand1) == "none of the above", select = c(State_Name,PC_No, Cand1, Votes1, Vote_Sh))
    AE_state_NOTA$NOTA_percent <- AE_state_NOTA$Vote_Sh
    AE_state_NOTA <- subset(AE_state_NOTA, select = c(State_Name,PC_No, NOTA_percent))
    AE_state_main <- merge(AE_state_main, AE_state_NOTA, by=c("State_Name","PC_No"))
  }else {
    AE_state_main$NOTA_percent <- NA
  }
# appending the AE_state_main to AE_maps general data frame
  GE_maps_general <- rbind.fill(GE_maps_general, AE_state_main)
}
}
   # outputs need to be in basepath/dependent_files/lokdhaba/
####################first create the directory if not present#####################################
#check if a directory exist in ../lokdhaba_data_infosys/graphs/%s, if not then create it
CreateDirIfAbsent(lokdhabapath)

# Timeline graphs - 
GE_state_contested <- GE_timeline_general[ , c("Year","ga_no","month", "Parties contested", "Parties represented")]
#dir.create(ars[1], showWarnings = TRUE, recursive = FALSE, mode = "0777")
#AE_state_contested$State<-STATENAME
setnames(GE_state_contested, old=c("Year","Parties contested","Parties represented"), new=c("year","parties_contested","parties_represented"))
write.csv(GE_state_contested, file = paste(lokdhabapath,"ge_parties_contests.csv", sep="/"),row.names=FALSE)
# 
GE_state_deposit <-GE_timeline_general[ , c("Year", "ga_no","month","Total Candidates", "Deposit Saved")]
#AE_state_deposit$State<-STATENAME
setnames(GE_state_deposit, old=c("Year","Total Candidates","Deposit Saved"), new=c("year","total_candidates","deposit_saved"))
write.csv(GE_state_deposit, file = paste(lokdhabapath,"ge_contested_deposit_losts.csv", sep="/"),row.names=FALSE)
# 
GE_women_percentage <-GE_timeline_general[ , c( "Year", "ga_no","month","Women percentage")]
#AE_women_percentage$State<-STATENAME
setnames(GE_women_percentage, old=c("Year","Women percentage"), new=c("year","women_percentage"))
write.csv(GE_women_percentage, file = paste(lokdhabapath,"ge_womens.csv",sep="/"),row.names=FALSE)

# Maps general - 
# Making some adhoc changes for visualization
GE_maps_general$Sex1<-as.character(GE_maps_general$Sex1)
GE_maps_general$Sex1[GE_maps_general$Sex1 == "M"] <- "Male"
GE_maps_general$Sex1[GE_maps_general$Sex1 == "F"] <- "Female"
GE_maps_general$PC_Type<-as.character(GE_maps_general$PC_Type)
GE_maps_general$PC_Type[GE_maps_general$PC_Type == "GEN"] <- "General"
GE_maps_general$Rel<-as.character(GE_maps_general$Rel)
GE_maps_general$Rel[GE_maps_general$Rel == "H"] <- "Hindu"
GE_maps_general$Rel[GE_maps_general$Rel == "M"] <- "Muslim"
GE_maps_general$Rel[GE_maps_general$Rel == "C"] <- "Christian"
#setnames(AE_maps_general, old=c("State","Year","Women percentage"), new=c("state","year","women_percentage"))
#print(names(AE_maps_general))
    GE_maps_general<-subset(GE_maps_general,select=c("State_Name","Year","ga_no","month","PC_No","PC_Name","Turnout","Vote_Sh","PC_Type","Electors","Margin","N_Cand","Position","Sex1","Party1","Votes1","Cand1","Rel","Margin_Percent","Runner","Runner_party","Runner_sex","NOTA_percent"))
setnames(GE_maps_general, old =c("State_Name","Year","PC_No","PC_Name","Turnout","Vote_Sh","PC_Type","Electors","Margin","N_Cand","Position","Sex1","Party1","Votes1","Cand1","Rel","Margin_Percent","Runner","Runner_party","Runner_sex","NOTA_percent"), new=c("state","year","pc_no","pc_name","turnout","vote_percent","pc_type","electors","margin","n_cand","position","sex1","party1","votes1","cand1","religion","margin_percent","runner","runner_party","runner_sex","nota_percent"))
    write.csv(GE_maps_general, file = paste(lokdhabapath,"ge_maps.csv", sep="/"),row.names=FALSE)

# Maps parties -
GE_parties_general<-
    subset(GE_mastersheet,
           select=c("State_Name","Year","ga_no","month","PC_No","PC_Name","PC_Type","Cand1","Party1","Votes1","Position","Vote_Sh"))

setnames(GE_parties_general,old=c("State_Name","Year","PC_No","PC_Name","PC_Type","Cand1","Party1","Votes1","Position","Vote_Sh"),new=c("state","year","pc_no","pc_name","pc_type","cand1","party1","votes1","position","vote_percent"))

write.csv(GE_parties_general,file=paste(lokdhabapath,"ge_partys.csv",sep="/"),row.names=FALSE)


    }


VoteShareLokDhaba<-function(a,lokdhabapath){

#names(a)
#winners = subset(a,a$Position==1,)
#winners = unique(winners)
winnerspro = subset(a,select=c("ga_no","Party1","Votes1","Electors","PC_No"))
winnerspro = unique(winnerspro)
yearsv<-(unique(subset(winnerspro,select=c("ga_no"))))
##Note that years variable now contain ga_no information. 
years<-as.vector(yearsv$ga_no)
years<-years[!is.na(years)]
#This was necessary because the extracted years might not be in sorted manner. This was impacting another line
#written in the same function >years[1] & <years[length(years)] and resulting in empty voteshare file.
years<-sort(years)

#how many votes have a party received for its candidates
vshareparty = aggregate(Votes1~ga_no+Party1,winnerspro,function(x) sum(x))
names(vshareparty)[3] = "Party_Votes"

#count total votes by all in a year..
totalvotes = aggregate(Party_Votes~ga_no,vshareparty,function(x) sum(x))
names(totalvotes)[2] = "Total_Votes"

m1 = merge(vshareparty,totalvotes,by.x=c("ga_no"),by.y=c("ga_no"))
# View(m1)
# View(m1)

m1$VoteShare = m1$Party_Votes*100/m1$Total_Votes
# View(m1)
#print(subset(m1,m1$Year==2016,select=c("Party1","Party_Votes","Total_Votes")))

#names(m1)
#print(subset(m1,select=c("Year","Party1","VoteShare")))
r = transform(m1,position=ave(VoteShare,ga_no,FUN=function(x) rank(-x,ties.method="first")))
rparty<- subset(r,r$position<=6,)#taking top 6 parties only
#print(r)
#######################for which all years do we need this data
#create a matrix..
#As years now contain list of ga_nos therefore the change below is correct (comparison with ga_no column)
partynames = subset(rparty,rparty$ga_no>=years[1] & rparty$ga_no<=years[length(years)], select=c("Party1"))
partynames = unique(partynames)



##########################Create a matrix...
pnamevector = as.vector(partynames$Party1)
voteshare_frame <- data.frame()

for( pt in pnamevector)
 {
  
  assinfo =  subset(r,r$Party1==pt,)
  for( yr in years)
   {
       if(is.na(yr))
           next
       v = subset(assinfo,assinfo$ga_no==yr,)
       if(nrow(v)!=0){
           if(nrow(v)!=1){
               print(v)
               stop('error')
               }
           gayear<-a$Year[a$ga_no==yr][1]#select first year only
           gamonth<-a$month[a$ga_no==yr][1]
           res1<-     data.frame( "year"=gayear,"ga_no"=yr,"month"=gamonth,"party"=pt, "votes"=trimws(round(v$VoteShare,digits=2)))
        voteshare_frame<-rbind(voteshare_frame,res1)
        }else
       {
                                      #if there was at least one candidate of this party in this state then st it as 0 else set as NA
        if(nrow(subset(a,a$ga_no==yr & a$Party1==pt,))==0){
                                        #                     res1<-     data.frame(state=STATENAME, year=yr,
                                        #                                          "party"=pt,
                                        #                                         "seates"="NA", check.names=F)
                                        #                  voteshare_frame<-rbind(voteshare_frame,res1)
        }else
         {
             gayear<-a$Year[a$ga_no==yr][1]#select first year only
           gamonth<-a$month[a$ga_no==yr][1]
             res1<-data.frame( "year"=gayear,"ga_no"=yr,"month"=gamonth,"party"=pt, "votes"="0")
             voteshare_frame<-rbind(voteshare_frame,res1)
         }
      }
    }
					  
}

CreateDirIfAbsent(lokdhabapath)
write.csv(voteshare_frame,paste(lokdhabapath,"ge_voteshares.csv",sep="/"),row.names=FALSE)
    }


SeatShareLokDhaba<-function(a,lokdhabapath){
    

#STATENAME<-a$State_Name[1]

#####################################################
winners = subset(a,a$Position==1,)
winners = unique(winners)
winnerspro = subset(winners,select=c("Year","ga_no","month","Party1","Votes1","Electors","PC_No"))
    #same changes as in voteshareLokDhaba function to incorporate ga_no based aggregation instead of year based aggregation
yearsv<-(unique(subset(winners,select=c("ga_no"))))
years<-as.vector(yearsv$ga_no)
years<-years[!is.na(years)]
#This was necessary because the extracted years might not be in sorted manner. This was impacting another line
#written in the same function >years[1] & <years[length(years)] and resulting in empty seatshare file.
years<-sort(years)

#print(years)
winnerspro = unique(winnerspro)
vshareparty = aggregate(PC_No~ga_no+Party1,winnerspro,function(x) length(x))
names(vshareparty)[3] = "Num_Winners"
totalwinners = aggregate(Num_Winners~ga_no,vshareparty,function(x) sum(x))
names(totalwinners)[2] = "TotalSeats"
m1 = merge(vshareparty,totalwinners,by.x=c("ga_no"),by.y=c("ga_no"))
m1$SeatShare = m1$Num_Winners/m1$TotalSeats
m1$SeatShare = m1$SeatShare*100
library(plyr)
r = transform(m1,position=ave(SeatShare,ga_no,FUN=function(x) rank(-x,ties.method="first")))
# View(r)
rparty = subset(r,r$position<=5,)

#######################for which all years do we need this data
#create a matrix..
partynames = subset(rparty,rparty$ga_no>=years[1] & rparty$ga_no<=years[length(years)], select=c("Party1"))
partynames = unique(partynames)


##########################Create a matrix...
pnamevector = as.vector(partynames$Party1)
seatshare_frame <- data.frame()

    for( pt in pnamevector)
    {
        assinfo =  subset(r,r$Party1==pt)
	for( yr in years)
	{
            v = subset(assinfo,assinfo$ga_no==yr)
	
	     if(nrow(v)!=0){
                      if(nrow(v)!=1){
                          print(v)
                          stop('error')
                      }
                      gamonth<-a$month[a$ga_no==yr][1]
                      gayear<-a$Year[a$ga_no==yr][1]#select first year only

                res1<-     data.frame( year=gayear, ga_no=yr,month=gamonth,
               "party"=pt,
               "seats"=trimws(round(v$SeatShare,digits=2)))
                seatshare_frame<-rbind(seatshare_frame,res1)
                
	     }else{
                     if(nrow(subset(a,a$Year==yr & a$Party1==pt,))==0){
 #                               res1<-data.frame(state=STATENAME, year=yr, "party"=pt, "seates"="NA", check.names=F)
 #                               seatshare_frame<-rbind(seatshare_frame,res1)
                 }else{
                                gayear<-a$Year[a$ga_no==yr][1]#select first year only
                      gamonth<-a$month[a$ga_no==yr][1]
                                res1<-data.frame(year=gayear,ga_no=yr,month=gamonth,"party"=pt,"seats"="0")
                                 seatshare_frame<-rbind(seatshare_frame,res1)
                     }
             }

        }
 }

CreateDirIfAbsent(lokdhabapath)
write.csv(seatshare_frame,paste(lokdhabapath,"ge_seatshares.csv",sep="/"),row.names=FALSE)




    }



    basepath=args[1]
    print(basepath)
    lokdhabapath=paste(basepath,"derived/lokdhaba",sep="/")
    CreateDirIfAbsent(lokdhabapath)
    mastersheet<-read.csv(paste(basepath,"derived/mastersheet.csv",sep="/"),stringsAsFactors=FALSE)
    GenLokDhabaFiles(mastersheet,lokdhabapath)
    VoteShareLokDhaba(mastersheet,lokdhabapath)
    SeatShareLokDhaba(mastersheet,lokdhabapath)
    
  
