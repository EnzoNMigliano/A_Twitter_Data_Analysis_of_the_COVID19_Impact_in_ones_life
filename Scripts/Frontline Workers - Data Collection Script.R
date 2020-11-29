# Enzo Novi Migliano, Arianna Lupi, Raul Ramon - Programming for Data Analytics



# Twitter data from that are working in the front line of the corona virus 



# The first step is to provide the security credential for access to the Twitter API

## I will not provide with my credentials 


# Getting the data 

## Loading and installing packages

###install.package("rtweet")
###install.package("tidyverse")
library(rtweet)
library(tidyverse)
library(lubridate)


## Searching for the tweets with the following keywords
## The key words are actually phrases which will help to identify the target demographic




targetSampleOfFrontLineWorkers <- search_tweets(q = "\"I am a nurse\" OR \"I am a doctor\" OR \"I am a caregiver\" OR \"I am a nursing home caregiver\" OR \"I am a nursing home worker\" OR \"I work at a hospital\" OR \"I work at a nursing home\" OR \"I work at the medical field\" AND -filter:verified",
                                                n = 1000, include_rts = FALSE)



## Although we strived to search for 1000 tweets, we were only able to gather 993


## Now we want to extract the user names of those tweets so we can have a better overview of their time line


UsernamesTargetSample <- 
  as.vector(unique(targetSampleOfFrontLineWorkers$screen_name))




## Lets check how many different usernames we have


length(UsernamesTargetSample)

## There are 993 different usernames in the data set


################################################################################



## Now we are going to perform a iteration to get the timelime of the
## target sample up to 200 tweets back in time 
## the median users tweets up to 2 tweets per month the most active ones up to 138 (cooper)
## therefore 250 tweets back in the timeline shold be enough for most of the people 
## https://www.datamentor.io/r-programming/list/
## We are going to perform an iteration to get the data

### setting the i to act as the incremnter of the loop starting at one 
i <- 1


### We are creating a list to store all the data from the users 
TargetSampleTimeline <- as.list(1:length(UsernamesTargetSample))


## We are going to place the data(the whole dataframe in the position i)
## We are getting the names of the users that were stored in the variable UsernamesTargetSample
## With the iteration the timeline accessed by the code will change according to the position of the vector UsernamesTargetSample

while(i <= length(UsernamesTargetSample)){
  TargetSampleTimeline[[i]] <- get_timeline(
    UsernamesTargetSample[[i]],
    n = 250,
    max_id = NULL,
    home = FALSE,
    parse = TRUE,
    check = TRUE,
    token = NULL)
  i <- i + 1
}

## The request was too big for twitter since the iteration only returned 180 of 993 users
TargetSampleTimeline1 <- TargetSampleTimeline[1:180]

## Therefore I will divide the time lines into groups of 100 usernames

UsernamesTargetSample2 <- UsernamesTargetSample[200:299]
UsernamesTargetSample3 <- UsernamesTargetSample[300:399]
UsernamesTargetSample4 <- UsernamesTargetSample[400:499]
UsernamesTargetSample5 <- UsernamesTargetSample[500:599]
UsernamesTargetSample6 <- UsernamesTargetSample[600:699]
UsernamesTargetSample7 <- UsernamesTargetSample[700:799]
UsernamesTargetSample8 <- UsernamesTargetSample[800:899]
UsernamesTargetSample9 <- UsernamesTargetSample[900:993]


## for the position 200
i <- 1
TargetSampleTimeline2 <- as.list(1:length(UsernamesTargetSample2))
while(i <= length(UsernamesTargetSample2)){
  TargetSampleTimeline2[[i]] <- get_timeline(
    UsernamesTargetSample2[[i]],
    n = 250,
    max_id = NULL,
    home = FALSE,
    parse = TRUE,
    check = TRUE,
    token = NULL)
  i <- i + 1
}

## for the position 300 (missing the last 20 rows)
i <- 1
TargetSampleTimeline3 <- as.list(1:length(UsernamesTargetSample3))
while(i <= length(UsernamesTargetSample3)){
  TargetSampleTimeline3[[i]] <- get_timeline(
    UsernamesTargetSample3[[i]],
    n = 250,
    max_id = NULL,
    home = FALSE,
    parse = TRUE,
    check = TRUE,
    token = NULL)
  i <- i + 1
}

## for the position 400
i <- 1
TargetSampleTimeline4 <- as.list(1:length(UsernamesTargetSample4)) 
while(i <= length(UsernamesTargetSample4)){
  TargetSampleTimeline4[[i]] <- get_timeline(
    UsernamesTargetSample4[[i]],
    n = 250,
    max_id = NULL,
    home = FALSE,
    parse = TRUE,
    check = TRUE,
    token = NULL)
  i <- i + 1
}

## for the position 500 (missing the last 20 rows)
i <- 1
TargetSampleTimeline5 <- as.list(1:length(UsernamesTargetSample5)) 
while(i <= length(UsernamesTargetSample5)){
  TargetSampleTimeline5[[i]] <- get_timeline(
    UsernamesTargetSample5[[i]],
    n = 250,
    max_id = NULL,
    home = FALSE,
    parse = TRUE,
    check = TRUE,
    token = NULL)
  i <- i + 1
}

## for the position 600
i <- 1
TargetSampleTimeline6 <- as.list(1:length(UsernamesTargetSample6)) 
while(i <= length(UsernamesTargetSample6)){
  TargetSampleTimeline6[[i]] <- get_timeline(
    UsernamesTargetSample6[[i]],
    n = 250,
    max_id = NULL,
    home = FALSE,
    parse = TRUE,
    check = TRUE,
    token = NULL)
  i <- i + 1
}

## for the position 700
i <- 1
TargetSampleTimeline7 <- as.list(1:length(UsernamesTargetSample7))
while(i <= length(UsernamesTargetSample7)){
  TargetSampleTimeline7[[i]] <- get_timeline(
    UsernamesTargetSample7[[i]],
    n = 250,
    max_id = NULL,
    home = FALSE,
    parse = TRUE,
    check = TRUE,
    token = NULL)
  i <- i + 1
}

## for the position 800
i <- 1
TargetSampleTimeline8 <- as.list(1:length(UsernamesTargetSample8))
while(i <= length(UsernamesTargetSample8)){
  TargetSampleTimeline8[[i]] <- get_timeline(
    UsernamesTargetSample8[[i]],
    n = 250,
    max_id = NULL,
    home = FALSE,
    parse = TRUE,
    check = TRUE,
    token = NULL)
  i <- i + 1
}

## for the position 900
i <- 1
TargetSampleTimeline9 <- as.list(1:length(UsernamesTargetSample9))
while(i <= length(UsernamesTargetSample9)){
  TargetSampleTimeline9[[i]] <- get_timeline(
    UsernamesTargetSample9[[i]],
    n = 250,
    max_id = NULL,
    home = FALSE,
    parse = TRUE,
    check = TRUE,
    token = NULL)
  i <- i + 1
}

## excluding the observation with no data due to rate limit

TargetSampleTimeline3 <- TargetSampleTimeline3[1:80]


TargetSampleTimeline5 <- TargetSampleTimeline5[1:80]


TargetSampleTimeline7 <- TargetSampleTimeline7[1:80]


TargetSampleTimeline9 <- TargetSampleTimeline9[1:80]

## for the remaining ones which were not possible to download due to rate limit

## 181-199 381-399 581-599 781-799 881-923

remainingUsernames <- c(UsernamesTargetSample[181:199], 
                              UsernamesTargetSample[381:399],
                              UsernamesTargetSample[581:599],
                              UsernamesTargetSample[781:799],
                              UsernamesTargetSample[881:923])

### performing the iteration

i <- 1
TargetSampleTimelineRemaning <- as.list(1:length(remainingUsernames))
while(i <= length(remainingUsernames)){
  TargetSampleTimelineRemaning[[i]] <- get_timeline(
    remainingUsernames[[i]],
    n = 250,
    max_id = NULL,
    home = FALSE,
    parse = TRUE,
    check = TRUE,
    token = NULL)
  i <- i + 1
}


################################################################################


## Now we are going to perform an iteration to compile all the data from lists into a data frames
## The iterations will assign each potion of the list to a variable called data frame
## Then we are going to row bind it one by one until we have all the data of the list in one data frame

## for the position 0-199

j <- 2

TargetSampleTimelineFinal1 <- TargetSampleTimeline1[[1]]
while(j <= length(TargetSampleTimeline1)){
  dataframe <- TargetSampleTimeline1[[j]]
  TargetSampleTimelineFinal1 <- rbind(TargetSampleTimelineFinal1, dataframe)
  
  j <- j + 1
}


## for the position 200
j <- 2

TargetSampleTimelineFinal2 <- TargetSampleTimeline2[[1]]
while(j <= length(TargetSampleTimeline2)){
  dataframe <- TargetSampleTimeline2[[j]]
  TargetSampleTimelineFinal2 <- rbind(TargetSampleTimelineFinal2, dataframe)
  
  j <- j + 1
}


## for the position 300
j <- 2

TargetSampleTimelineFinal3 <- TargetSampleTimeline3[[1]]
while(j <= length(TargetSampleTimeline3)){
  dataframe <- TargetSampleTimeline3[[j]]
  TargetSampleTimelineFinal3 <- rbind(TargetSampleTimelineFinal3, dataframe)
  
  j <- j + 1
}


## for the position 400
j <- 2

TargetSampleTimelineFinal4 <- TargetSampleTimeline4[[1]]
while(j <= length(TargetSampleTimeline4)){
  dataframe <- TargetSampleTimeline4[[j]]
  TargetSampleTimelineFinal4 <- rbind(TargetSampleTimelineFinal4, dataframe)
  
  j <- j + 1
}


## for the position 500

j <- 2

TargetSampleTimelineFinal5 <- TargetSampleTimeline5[[1]]
while(j <= length(TargetSampleTimeline5)){
  dataframe <- TargetSampleTimeline5[[j]]
  TargetSampleTimelineFinal5 <- rbind(TargetSampleTimelineFinal5, dataframe)
  
  j <- j + 1
}

## for the position 600
j <- 2

TargetSampleTimelineFinal6 <- TargetSampleTimeline6[[1]]
while(j <= length(TargetSampleTimeline6)){
  dataframe <- TargetSampleTimeline6[[j]]
  TargetSampleTimelineFinal6 <- rbind(TargetSampleTimelineFinal6, dataframe)
  
  j <- j + 1
}


## for the position 700
j <- 2

TargetSampleTimelineFinal7 <- TargetSampleTimeline7[[1]]
while(j <= length(TargetSampleTimeline7)){
  dataframe <- TargetSampleTimeline7[[j]]
  TargetSampleTimelineFinal7 <- rbind(TargetSampleTimelineFinal7, dataframe)
  
  j <- j + 1
}


## for the position 800
j <- 2

TargetSampleTimelineFinal8 <- TargetSampleTimeline8[[1]]
while(j <= length(TargetSampleTimeline8)){
  dataframe <- TargetSampleTimeline8[[j]]
  TargetSampleTimelineFinal8 <- rbind(TargetSampleTimelineFinal8, dataframe)
  
  j <- j + 1
}


## for the position 900

j <- 2

TargetSampleTimelineFinal9 <- TargetSampleTimeline9[[1]]
while(j <= length(TargetSampleTimeline9)){
  dataframe <- TargetSampleTimeline9[[j]]
  TargetSampleTimelineFinal9 <- rbind(TargetSampleTimelineFinal9, dataframe)
  
  j <- j + 1
}

## for the remaining 


j <- 2

TargetSampleTimelineRemaningFinal <- TargetSampleTimelineRemaning[[1]]
while(j <= length(TargetSampleTimelineRemaning)){
  dataframe <- TargetSampleTimelineRemaning[[j]]
  TargetSampleTimelineRemaningFinal <- rbind(TargetSampleTimelineRemaningFinal,
                                             dataframe)
  
  j <- j + 1
}



################################################################################



## putting all the parts of the tweets into one single data frame

FinalDataSetFrontLineWorkersTwitter <- rbind(TargetSampleTimelineFinal1, 
                                             TargetSampleTimelineFinal2)


## Adding the 300

FinalDataSetFrontLineWorkersTwitter <- rbind(FinalDataSetFrontLineWorkersTwitter, 
                                             TargetSampleTimelineFinal3)


## Adding the 400

FinalDataSetFrontLineWorkersTwitter <- rbind(FinalDataSetFrontLineWorkersTwitter, 
                                             TargetSampleTimelineFinal4)

## Adding the 500

FinalDataSetFrontLineWorkersTwitter <- rbind(FinalDataSetFrontLineWorkersTwitter, 
                                             TargetSampleTimelineFinal5)

## Adding the 600

FinalDataSetFrontLineWorkersTwitter <- rbind(FinalDataSetFrontLineWorkersTwitter, 
                                             TargetSampleTimelineFinal6)
## Adding the 700

FinalDataSetFrontLineWorkersTwitter <- rbind(FinalDataSetFrontLineWorkersTwitter, 
                                             TargetSampleTimelineFinal7)
## Adding the 800

FinalDataSetFrontLineWorkersTwitter <- rbind(FinalDataSetFrontLineWorkersTwitter, 
                                             TargetSampleTimelineFinal8)
## Adding the 900

FinalDataSetFrontLineWorkersTwitter <- rbind(FinalDataSetFrontLineWorkersTwitter,
                                             TargetSampleTimelineFinal9)

## adding the reaming ones

FinalDataSetFrontLineWorkersTwitter <- rbind(FinalDataSetFrontLineWorkersTwitter,
                                             TargetSampleTimelineRemaningFinal)





## Below is the final data set for the analysis on the frontline workers

FinalDataSetFrontLineWorkersTwitter

## the next script will be tidying the data
## As well as writing it as a CSV