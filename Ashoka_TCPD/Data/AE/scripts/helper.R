CreateDirIfAbsent<-function(path){
    #check if a directory exist , if not then create it
    res<-dir.exists(path)
    if(!res){
        dir.create(file.path(path),recursive=TRUE)
    }
}

canonicalizeACNames<-function(name){

    #convert to upper case after trimming
    t<-toupper(trimws(name))
    #replace spaces with empty strings
    t<-gsub("( )+","",t)
    #replace (SC) or (ST) or (BL) with empty string
    t<-gsub("(SC)","",t,fixed=TRUE)
    t<-gsub("(ST)","",t,fixed=TRUE)
    t<-gsub("(BL)","",t,fixed=TRUE)
    }


canonicalizePartyNames<-function(name){

    #convert to upper case after trimming
    t<-toupper(trimws(name))
    #replace spaces with empty strings
    #t<-gsub("( )+","",t)
    }

