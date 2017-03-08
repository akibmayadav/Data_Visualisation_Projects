suppressWarnings(suppressMessages(library(plyr)))
suppressWarnings(suppressMessages(library(gdata)))
suppressWarnings(suppressMessages(library(data.table)))
suppressWarnings(suppressMessages(library(plyr)))
source("helper.R")
args = commandArgs(TRUE)
if (length(args) != 1)  {

    stop ("Please provide 1 argument:  Root directory of the  state name for which lokdhaba files need to be generated")
}



GenLokDhabaFiles<-function(state_mastersheet,lokdhabapath){
      
AE_state_timeline_general <- data.frame(State=character(), Year=character(),
               "Parties contested"=integer(),
               "Parties represented"=integer(),
               "Total Candidates"=integer(),
               "Women percentage"=integer(),
               "Deposit Saved"=integer(), check.names=F)

AE_maps_general <- data.frame()

# Rolling it over the years in the mastersheet
    #change: now roll over the sa_no not the years..:To be done
    #Done:20 Dec. now iterate over sa_no not over years
for (sano in unique(state_mastersheet$sa_no)){
 if(is.na(sano))
   next
  
  statename <- as.character(state_mastersheet$State_Name[state_mastersheet$sa_no==sano][1])
# To get the total number of parties contesting and parties represented in every assembly
  state_mastersheet_year <- state_mastersheet[state_mastersheet$sa_no== sano,]
  parties_contested <- length(unique(state_mastersheet_year[,c("Party1")]))
  state_mastersheet_year_winners <- state_mastersheet[state_mastersheet$sa_no== sano & state_mastersheet$Position == 1,]
  parties_represented <- length(unique(state_mastersheet_year_winners[,c("Party1")]))

  #we can use any year (if an election sa_no split over two years for display purpose)
  year <- state_mastersheet_year$Year[1]
# To get the number of candidates contested and the no of candidates who lost their deposit
  candidates_contesting_elections <- nrow(state_mastersheet_year[state_mastersheet_year$Cand1 != "None of the Above",])
    candidates_lost_deposit_ld <-
    nrow(state_mastersheet_year[tolower(state_mastersheet_year$Cand1) != "none of the above" & state_mastersheet_year$Deposit_Lost == 'no',])

# To get the women winners percentage
    women_winners_percentage <-
    round(nrow(state_mastersheet_year_winners[tolower(state_mastersheet_year_winners$Sex1) == "f",])*100/nrow(state_mastersheet_year_winners),
          digits = 2)

# rbind states that merging objects demands matching names:
#print(statename)
    AE_state_timeline_general <- rbind(AE_state_timeline_general,
          data.frame(State = statename, Year = as.character(year),
                     sa_no = sano,
                     "Parties contested" = parties_contested,
                     "Parties represented" = parties_represented,
                     "Total Candidates" = candidates_contesting_elections,
                     "Deposit Saved" = candidates_lost_deposit_ld,
                     "Women percentage" = women_winners_percentage,
                     check.names=F))
  
#print(nrow(AE_state_timeline_general))
# To get the general values for the maps 
    AE_state_main <-
    subset(state_mastersheet_year, Position == 1,
           select = c(State_Name,sa_no, Year, month,AC_No, AC_Name, Turnout,Vote_Sh,AC_Type, Electors,  Margin, N_Cand, Position, Sex1, Party1, Votes1, Cand1,  Margin_Percent))
    #AE_state_main$Turnout <- as.numeric(AE_state_main$Voters)*100/as.numeric(AE_state_main$Electors)
    AE_state_main$Margin_percent <- AE_state_main$Margin_Percent
    AE_state_main$Vote_percent <- AE_state_main$Vote_Sh
    AE_state_main$State <- AE_state_main$State_Name
    
  if (2 %in% state_mastersheet_year$Position){
    AE_state_Runner <- subset(state_mastersheet_year, Position == 2, select = c(AC_No,  Sex1, Party1, Votes1, Cand1, Vote_Sh))
    AE_state_Runner$Vote_percent <- AE_state_Runner$Vote_Sh
    AE_state_Runner <- subset(AE_state_Runner, select = c(AC_No, Cand1, Party1, Sex1))
    AE_state_Runner <- setNames(AE_state_Runner, c("AC_No","Runner","Runner_party", "Runner_sex"))
    AE_state_main <- merge(AE_state_main, AE_state_Runner, by="AC_No",all.x=T)
  }else {
    AE_state_main$Runner <- NA
    AE_state_main$Runner_party <- NA
    AE_state_main$Runner_sex <- NA
  }
    #print(AE_state_main)
  if ('none of the above' %in% tolower(state_mastersheet_year$Cand1)){
    AE_state_NOTA <- subset(state_mastersheet_year, tolower(Cand1) == "none of the above", select = c(AC_No, Cand1, Votes1, Vote_Sh))
    AE_state_NOTA$NOTA_percent <- AE_state_NOTA$Vote_Sh
    AE_state_NOTA <- subset(AE_state_NOTA, select = c(AC_No, NOTA_percent))
    AE_state_main <- merge(AE_state_main, AE_state_NOTA, by="AC_No")
  }else {
    AE_state_main$NOTA_percent <- NA
  }
# appending the AE_state_main to AE_maps general data frame
    
  AE_maps_general <- rbind.fill(AE_maps_general, AE_state_main)
}

   # outputs need to be in basepath/dependent_files/lokdhaba/
####################first create the directory if not present#####################################
#check if a directory exist in ../lokdhaba_data_infosys/graphs/%s, if not then create it

# Timeline graphs - 
AE_state_contested <- AE_state_timeline_general[ , c("State","sa_no","Year", "Parties contested", "Parties represented")]
#dir.create(ars[1], showWarnings = TRUE, recursive = FALSE, mode = "0777")
#AE_state_contested$State<-STATENAME
setnames(AE_state_contested, old=c("State","Year","Parties contested","Parties represented"), new=c("state","year","parties_contested","parties_represented"))
write.csv(AE_state_contested, file = paste(lokdhabapath,"ae_parties_contests.csv", sep="/"),row.names=FALSE)
# 
AE_state_deposit <-AE_state_timeline_general[ , c("State","sa_no","Year", "Total Candidates", "Deposit Saved")]
#AE_state_deposit$State<-STATENAME
setnames(AE_state_deposit, old=c("State","Year","Total Candidates","Deposit Saved"), new=c("state","year","total_candidates","deposit_saved"))
write.csv(AE_state_deposit, file = paste(lokdhabapath,"ae_contested_deposit_losts.csv", sep="/"),row.names=FALSE)
# 
AE_women_percentage <-AE_state_timeline_general[ , c("State","sa_no", "Year", "Women percentage")]
#AE_women_percentage$State<-STATENAME
setnames(AE_women_percentage, old=c("State","Year","Women percentage"), new=c("state","year","women_percentage"))
write.csv(AE_women_percentage, file = paste(lokdhabapath,"ae_womens.csv",sep="/"),row.names=FALSE)

# Maps general - 
# Making some adhoc changes for visualization
AE_maps_general$Sex1<-as.character(AE_maps_general$Sex1)
AE_maps_general$Sex1[AE_maps_general$Sex1 == "M"] <- "Male"
AE_maps_general$Sex1[AE_maps_general$Sex1 == "F"] <- "Female"
AE_maps_general$AC_Type<-as.character(AE_maps_general$AC_Type)
AE_maps_general$AC_Type[AE_maps_general$AC_Type == "GEN"] <- "General"
#Rel handling is not clear.. as electoral data does not contain this information
#where should it come from?
#AE_maps_general$Rel<-as.character(AE_maps_general$Rel)
#AE_maps_general$Rel[AE_maps_general$Rel == "H"] <- "Hindu"
#AE_maps_general$Rel[AE_maps_general$Rel == "M"] <- "Muslim"
#AE_maps_general$Rel[AE_maps_general$Rel == "C"] <- "Christian"
#setnames(AE_maps_general, old=c("State","Year","Women percentage"), new=c("state","year","women_percentage"))
#print(names(AE_maps_general))
    AE_maps_general<-subset(AE_maps_general,select=c("State","sa_no","Year","month","AC_No","AC_Name","Turnout","Vote_Sh","AC_Type","Electors","Margin","N_Cand","Position","Sex1","Party1","Votes1","Cand1","Margin_Percent","Runner","Runner_party","Runner_sex","NOTA_percent"))
setnames(AE_maps_general, old =c("State","Year","sa_no","month","AC_No","AC_Name","Turnout","Vote_Sh","AC_Type","Electors","Margin","N_Cand","Position","Sex1","Party1","Votes1","Cand1","Margin_Percent","Runner","Runner_party","Runner_sex","NOTA_percent"), new=c("state","year","sa_no","month","ac_no","ac_name","turnout","vote_percent","ac_type","electors","margin","n_cand","position","sex1","party1","votes1","cand1","margin_percent","runner","runner_party","runner_sex","nota_percent"))
    write.csv(AE_maps_general, file = paste(lokdhabapath,"ae_maps.csv", sep="/"),row.names=FALSE)

# Maps parties -
AE_parties_general<-
    subset(state_mastersheet,
           select=c("State_Name","Year","AC_No","AC_Name","AC_Type","Cand1","Party1","Votes1","Position","Vote_Sh"))

#AE_parties_general$State_Name<-STATENAME
setnames(AE_parties_general,old=c("State_Name","Year","AC_No","AC_Name","AC_Type","Cand1","Party1","Votes1","Position","Vote_Sh"),new=c("state","year","ac_no","ac_name","ac_type","cand1","party1","votes1","position","vote_percent"))

write.csv(AE_parties_general,file=paste(lokdhabapath,"ae_partys.csv",sep="/"),row.names=FALSE)


    }


VoteShareLokDhaba<-function(state_mastersheet,lokdhabapath){
      

partyvotes = subset(state_mastersheet,select=c("sa_no","Party1","Votes1","Electors","AC_No"))
partyvotes = unique(partyvotes)
yearsv<-(unique(subset(partyvotes,select=c("sa_no"))))
years<-as.vector(yearsv$sa_no)
years<-years[!is.na(years)]
years<-sort(years)
#print(years)
#how many votes have a party received for its candidates
vshareparty = aggregate(Votes1~sa_no+Party1,partyvotes,function(x) sum(x))
names(vshareparty)[3] = "Party_Votes"

#count total votes by all in a year..
totalvotes = aggregate(Party_Votes~sa_no,vshareparty,function(x) sum(x))
names(totalvotes)[2] = "Total_Votes"

m1 = merge(vshareparty,totalvotes,by.x=c("sa_no"),by.y=c("sa_no"))
# View(m1)
# View(m1)

m1$VoteShare = m1$Party_Votes*100/m1$Total_Votes
# View(m1)
#print(subset(m1,m1$Year==2016,select=c("Party1","Party_Votes","Total_Votes")))

#names(m1)
#print(subset(m1,select=c("Year","Party1","VoteShare")))
r = transform(m1,position=ave(VoteShare,sa_no,FUN=function(x) rank(-x,ties.method="first")))
rparty<- subset(r,r$position<=6,)
#print(r)

#######################for which all years do we need this data
#create a matrix..
partynames = subset(rparty,rparty$sa_no>=years[1] & rparty$sa_no<=years[length(years)], select=c("Party1"))
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
	     v = subset(assinfo,assinfo$sa_no==yr,)
	     #print(nrow(v))
	     #print(state)
	     #print(assembly)
	     if(nrow(v)!=0){
                 STATENAME<-state_mastersheet$State_Name[state_mastersheet$sa_no==yr][1]
                 sayear<-state_mastersheet$Year[state_mastersheet$sa_no==yr][1]#select first year only
                 samonth<-state_mastersheet$month[state_mastersheet$sa_no==yr][1]
    
                res1<-     data.frame(state=STATENAME, "year"=sayear, "month"=samonth,
               "party"=pt,
               "votes"=trimws(round(v$VoteShare,digits=2)))
                voteshare_frame<-rbind(voteshare_frame,res1)
	     }else
                 {
                     #if there was at least one candidate of this party in this state then st it as 0 else set as NA
                     if(nrow(subset(state_mastersheet,state_mastersheet$sa_no==yr & state_mastersheet$Party1==pt,))==0){
#                     res1<-     data.frame(state=STATENAME, year=yr,
 #                                          "party"=pt,
  #                                         "seats"="NA", check.names=F)
   #                  voteshare_frame<-rbind(voteshare_frame,res1)
                     }else
                         {
                              STATENAME<-state_mastersheet$State_Name[state_mastersheet$sa_no==yr][1]
                              sayear<-state_mastersheet$Year[state_mastersheet$sa_no==yr][1]#select first year only
                              samonth<-state_mastersheet$month[state_mastersheet$sa_no==yr][1]
    
                              res1<-     data.frame(state=STATENAME, "year"=sayear, "month"=samonth,
                                                    "party"=pt,
                                                    "votes"="0")
                              voteshare_frame<-rbind(voteshare_frame,res1)
                             }
                     }
                
            
	  }
	#finalres['Total',as.character(assembly)]=sum(finalres[,as.character(assembly)])
 }

write.csv(voteshare_frame,paste(lokdhabapath,"ae_voteshares.csv",sep="/"),row.names=FALSE)
    }


SeatShareLokDhaba<-function(state_mastersheet,lokdhabapath){
      
#STATENAME<-a$State_Name[1] Same handling as done in VoteShareLokDhaba function is needed here as well.
#####################################################
winners = subset(state_mastersheet,state_mastersheet$Position==1,)
winners = unique(winners)
winnerspro = subset(winners,select=c("sa_no","Party1","Votes1","Electors","AC_No"))
yearsv<-(unique(subset(winners,select=c("sa_no"))))
years<-as.vector(yearsv$sa_no)
years<-years[!is.na(years)]
years<-sort(years)
#print(years)
winnerspro = unique(winnerspro)
vshareparty = aggregate(AC_No~sa_no+Party1,winnerspro,function(x) length(x))
names(vshareparty)[3] = "Num_Winners"
totalwinners = aggregate(Num_Winners~sa_no,vshareparty,function(x) sum(x))
names(totalwinners)[2] = "TotalSeats"
m1 = merge(vshareparty,totalwinners,by.x=c("sa_no"),by.y=c("sa_no"))
m1$SeatShare = m1$Num_Winners/m1$TotalSeats
m1$SeatShare = m1$SeatShare*100
suppressWarnings(suppressMessages(library(plyr)))
r = transform(m1,position=ave(SeatShare,sa_no,FUN=function(x) rank(-x,ties.method="first")))
# View(r)
rparty = subset(r,r$position<=5,)

#######################for which all years do we need this data
#create a matrix..
partynames = subset(rparty,rparty$sa_no>=years[1] & rparty$sa_no<=years[length(years)], select=c("Party1"))
partynames = unique(partynames)


##########################Create a matrix...
pnamevector = as.vector(partynames$Party1)
seatshare_frame <- data.frame()
for( pt in pnamevector)
  {
	   assinfo =  subset(r,r$Party1==pt)
	   for( yr in years)
	    {
	     v = subset(assinfo,assinfo$sa_no==yr)
	     #print(nrow(v))
	     #print(state)
             
	     #print(assembly)
	     if(nrow(v)!=0){
                  STATENAME<-state_mastersheet$State_Name[state_mastersheet$sa_no==yr][1]
                 sayear<-state_mastersheet$Year[state_mastersheet$sa_no==yr][1]#select first year only
                 samonth<-state_mastersheet$month[state_mastersheet$sa_no==yr][1]
                res1<-     data.frame(state=STATENAME, "year"=sayear, "month"=samonth,
               "party"=pt,
               "seats"=trimws(round(v$SeatShare,digits=2)))
                seatshare_frame<-rbind(seatshare_frame,res1)
                
	     }else{
                     if(nrow(subset(state_mastersheet,state_mastersheet$sa_no==yr & state_mastersheet$Party1==pt,))==0){
 #                               res1<-data.frame(state=STATENAME, year=yr, "party"=pt, "seats"="NA", check.names=F)
 #                               seatshare_frame<-rbind(seatshare_frame,res1)
                 }else{
                          STATENAME<-state_mastersheet$State_Name[state_mastersheet$sa_no==yr][1]
                          sayear<-state_mastersheet$Year[state_mastersheet$sa_no==yr][1]#select first year only
                          samonth<-state_mastersheet$month[state_mastersheet$sa_no==yr][1]
                          res1<-     data.frame(state=STATENAME, "year"=sayear, "month"=samonth,
                                                "party"=pt,
                                                "seats"="0")
                          seatshare_frame<-rbind(seatshare_frame,res1)
                     }
             }
          }
  #finalres['Total',as.character(assembly)]=sum(finalres[,as.character(assembly)])
 }

write.csv(seatshare_frame,paste(lokdhabapath,"ae_seatshares.csv",sep="/"),row.names=FALSE)

    }


    basepath=args[1]
    print(basepath)
    lokdhabapath=paste(basepath,"derived/lokdhaba",sep="/")
    CreateDirIfAbsent(lokdhabapath)
    mastersheet<-read.csv(paste(basepath,"derived/mastersheet.csv",sep="/"),stringsAsFactors=FALSE)
    GenLokDhabaFiles(mastersheet,lokdhabapath)
    VoteShareLokDhaba(mastersheet,lokdhabapath)
    SeatShareLokDhaba(mastersheet,lokdhabapath)
    
  
