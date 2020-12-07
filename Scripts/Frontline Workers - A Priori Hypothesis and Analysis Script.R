# Enzo Novi Migliano, Arianna Lupi, Raul Ramon - Programming for Big Data Analytics


## Analysis of the data - Front Line Workers


################################################################################
################################################################################


## Installing & Loading necessary packages

#install.packages("arules")
#install.packages("arulesViz")
#install.packages("lubridate")
#install.packages("syuzhet")
#install.packages("wordcloud2")
#install.packages("stringr") 
#install.packages("tm")
#install.packages("quanteda")
#install.packages("reshape2")
#install.packages("lda")
#install.packages("tidyverse")
#install.packages("party")
#install.packages("rpart")
#install.packages("rpart.plot")
#install.packages("caTools")
#install.packages("e1071")
#install.packages("forecast")
#install.packages("ModelMetrics")
#install.packages("corrplot")





library(tidyverse)
library(arules)
library(arulesViz)
library(lubridate)
library(stringr)
library(tm)
library(quanteda)
library(reshape2)
library(lda)
library(syuzhet)
library(wordcloud2)
library(party)
library(rpart)
library(rpart.plot)
library(caTools)
library(e1071)
library(ModelMetrics)
library(forecast)
library(corrplot)





################################################################################


## Loading the data set






################################################################################


## Sentiment Analysis/Text Analysis

## Before 2020

## We are going to select the tweets from the final tweets data set 

frontlineTweetsBefore2020 <- FinalDataSetFrontLineWorkersTwitter %>% 
  select(text, created_at) %>% 
  filter(year(created_at) != 2020) %>% 
  select(-created_at)

## There were 45696 Tweets before 2020


## We now are going to eliminate all the stop words adn the pontuation from the tweets

FrontlineBeefore2020Corpus <- corpus(frontlineTweetsBefore2020)

FrontlineBeefore2020Tokens <- tokens(FrontlineBeefore2020Corpus)

FrontlineBeefore2020Tokens <- tokens(FrontlineBeefore2020Tokens, remove_punct = TRUE, 
                                     remove_numbers = TRUE)

FrontlineBeefore2020Tokens <- tokens_select(FrontlineBeefore2020Tokens,
                                            stopwords('english'),
                                            selection='remove')


## We now are going to combine words that are almost the same 

### Example workers, working, and worker would all become work 

FrontlineBeefore2020Tokens <- tokens_wordstem(FrontlineBeefore2020Tokens)

## We are now going to make all the words lower case to avoid count the same word twice

FrontlineBeefore2020Tokens <- tokens_tolower(FrontlineBeefore2020Tokens)


## Creating a document-feature matrix

FrontlineBefore2020DFM <- dfm(FrontlineBeefore2020Tokens)


## Getting the frequncy of each word from the tweets

FrontlineBefore2020DFMFrequency <- textstat_frequency(FrontlineBefore2020DFM)



## Visualizations 

quanteda::textplot_wordcloud(FrontlineBefore2020DFM, max_words = 200, 
                             color = brewer.pal(8, "Dark2"))


## Wordcloud2

## changing the names of the columns to utilize the wordcloud 2

FrontlineBefore2020DFMFrequencyLetterCloud <-
  FrontlineBefore2020DFMFrequency[, 1:2]

FrontlineBefore2020DFMFrequencyLetterCloud <-
  FrontlineBefore2020DFMFrequencyLetterCloud %>% 
  mutate(word = feature,
         freq = frequency)


FrontlineBefore2020DFMFrequencyLetterCloud <- 
  FrontlineBefore2020DFMFrequencyLetterCloud[, 3:4]


## Getting different lists of relevant words

FrontlineBefore2020DFMFrequencyLetterCloudFirst200 <-
  FrontlineBefore2020DFMFrequencyLetterCloud[1:200,]

FrontlineBefore2020DFMFrequencyLetterCloudFirst500 <-
  FrontlineBefore2020DFMFrequencyLetterCloud[1:500,]

FrontlineBefore2020DFMFrequencyLetterCloudFirst1000 <-
  FrontlineBefore2020DFMFrequencyLetterCloud[1:1000,]


## World cloud 2 for the tweets from the front line workers before 2020

wordcloud2(FrontlineBefore2020DFMFrequencyLetterCloudFirst200,
           shape = "pentagon",
           size = 0.50)



wordcloud2(FrontlineBefore2020DFMFrequencyLetterCloudFirst500,
           color = 'random-dark',
           shape = "pentagon",
           size = 0.45)


## Getting the sentiments and analyzing with NRC Word-Emotion Association Lexicon

### Getting the sentiments scores

### First we divide all the tweets in sentences

FrontlineBefore2020String <-
  get_sentences(as.vector(frontlineTweetsBefore2020$text))


### Then we get the sentiment of the words

FrontlineBefore2020NRCSentiment <- 
  get_nrc_sentiment(FrontlineBefore2020String)



FrontlineBefore2020NRCSentiment


### Now we construct a data frame that will cointain the sum of the sentiments observed

FrontlineBefore2020NRCSentimentNames <-
  as.data.frame(names(sort(colSums(FrontlineBefore2020NRCSentiment[,]))))

FrontlineBefore2020NRCSentimentValues <-
  sort(colSums(FrontlineBefore2020NRCSentiment[,]))

FrontlineBefore2020NRCSentimentNames
FrontlineBefore2020NRCSentimentValues[[1]]



FrontlineBefore2020NRCSentimentValues <-
  c(FrontlineBefore2020NRCSentimentValues[[1]],
    FrontlineBefore2020NRCSentimentValues[[2]],
    FrontlineBefore2020NRCSentimentValues[[3]],
    FrontlineBefore2020NRCSentimentValues[[4]],
    FrontlineBefore2020NRCSentimentValues[[5]],
    FrontlineBefore2020NRCSentimentValues[[6]],
    FrontlineBefore2020NRCSentimentValues[[7]],
    FrontlineBefore2020NRCSentimentValues[[8]],
    FrontlineBefore2020NRCSentimentValues[[9]],
    FrontlineBefore2020NRCSentimentValues[[10]])



FrontlineBefore2020NRCSentimentNames$Values <- 
  FrontlineBefore2020NRCSentimentValues



FrontlineBefore2020NRCSentimentNames <-
  FrontlineBefore2020NRCSentimentNames %>% 
  transmute(Sentiment = `names(sort(colSums(FrontlineBefore2020NRCSentiment[, ])))`,
            Values = Values)



FrontlineBefore2020NRCSentimentNames


## Visualizations

sum(FrontlineBefore2020NRCSentimentNames[1:8,2])



ggplot(data = FrontlineBefore2020NRCSentimentNames[1:8,],
       aes(x = Values,
           y = Sentiment)) +
  geom_bar(aes(fill = Sentiment),
           stat = "identity") +
  labs(title = "Front Line Workers Sentiments",
       subtitle = "Before 2020",
       caption = "Source: Twiiter API",
       x = "Count")


ggplot(data = FrontlineBefore2020NRCSentimentNames[9:10,],
       aes(x = Values,
           y = Sentiment)) +
  geom_bar(aes(fill = Sentiment),
           stat = "identity") +
  labs(title = "Front Line Workers Sentiments",
       subtitle = "Before 2020",
       caption = "Source: Twiiter API",
       x = "Count")










## First half of 2020 

## same steps as before 2020

## getting the data of the fist half

frontlineTweetsFrom2020H1 <- FinalDataSetFrontLineWorkersTwitter %>% 
  select(text, created_at) %>% 
  filter(year(created_at) == 2020) %>% 
  filter(month(created_at) %in% c(01,02,03,04,05,06)) %>% 
  select(-created_at)




## creating tokens

Frontline2020CorpusH1 <- corpus(frontlineTweetsFrom2020H1)

Frontline2020TokensH1 <- tokens(Frontline2020CorpusH1)

Frontline2020TokensH1 <- tokens(Frontline2020TokensH1, remove_punct = TRUE, 
                                remove_numbers = TRUE)

Frontline2020TokensH1 <- tokens_select(Frontline2020TokensH1,
                                       stopwords('english'),
                                       selection='remove')


Frontline2020TokensH1 <- tokens_wordstem(Frontline2020TokensH1)

Frontline2020TokensH1 <- tokens_tolower(Frontline2020TokensH1)


## Creating a document feature matrix


Frontline2020DFMH1 <- dfm(Frontline2020TokensH1)



Frontline2020DFMH1Frequency <- textstat_frequency(Frontline2020DFMH1)


## visualizations

quanteda::textplot_wordcloud(Frontline2020DFMH1, max_words = 200, 
                             color = brewer.pal(8, "Dark2"))




Frontline2020DFMH1FrequencyLetterCloud <-
  Frontline2020DFMH1Frequency[, 1:2]

Frontline2020DFMH1FrequencyLetterCloud <-
  Frontline2020DFMH1FrequencyLetterCloud %>% 
  mutate(word = feature,
         freq = frequency)


Frontline2020DFMH1FrequencyLetterCloud <- 
  Frontline2020DFMH1FrequencyLetterCloud[, 3:4]




Frontline2020DFMH1FrequencyLetterCloudFirst200 <-
  Frontline2020DFMH2FrequencyLetterCloud[1:200,]

Frontline2020DFMH1FrequencyLetterCloudFirst500 <-
  Frontline2020DFMH2FrequencyLetterCloud[1:500,]

Frontline2020DFMH1FrequencyLetterCloudFirst1000 <-
  Frontline2020DFMH2FrequencyLetterCloud[1:1000,]




wordcloud2(Frontline2020DFMH1FrequencyLetterCloudFirst500,
           shape = "pentagon",
           size = 0.45)


#### Getting the sentiments


frontlineTweetsFrom2020H1String <-
  get_sentences(as.vector(frontlineTweetsFrom2020H1$text))



frontlineTweetsFrom2020H1NRCSentiment <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H1String)



frontlineTweetsFrom2020H1NRCSentiment



frontlineTweetsFrom2020H1NRCSentimentNames <-
  as.data.frame(names(sort(colSums(frontlineTweetsFrom2020H1NRCSentiment[,]))))

frontlineTweetsFrom2020H1NRCSentimentValues <-
  sort(colSums(frontlineTweetsFrom2020H1NRCSentiment[,]))

frontlineTweetsFrom2020H1NRCSentimentNames
frontlineTweetsFrom2020H1NRCSentimentValues[[1]]



frontlineTweetsFrom2020H1NRCSentimentValues <-
  c(frontlineTweetsFrom2020H1NRCSentimentValues[[1]],
    frontlineTweetsFrom2020H1NRCSentimentValues[[2]],
    frontlineTweetsFrom2020H1NRCSentimentValues[[3]],
    frontlineTweetsFrom2020H1NRCSentimentValues[[4]],
    frontlineTweetsFrom2020H1NRCSentimentValues[[5]],
    frontlineTweetsFrom2020H1NRCSentimentValues[[6]],
    frontlineTweetsFrom2020H1NRCSentimentValues[[7]],
    frontlineTweetsFrom2020H1NRCSentimentValues[[8]],
    frontlineTweetsFrom2020H1NRCSentimentValues[[9]],
    frontlineTweetsFrom2020H1NRCSentimentValues[[10]])


frontlineTweetsFrom2020H1NRCSentimentNames$Values <- 
  frontlineTweetsFrom2020H1NRCSentimentValues



frontlineTweetsFrom2020H1NRCSentimentNames <-
  frontlineTweetsFrom2020H1NRCSentimentNames %>% 
  transmute(Sentiment = `names(sort(colSums(frontlineTweetsFrom2020H1NRCSentiment[, ])))`,
            Values = Values)



frontlineTweetsFrom2020H1NRCSentimentNames


###  visualizing the sentiments


ggplot(data = frontlineTweetsFrom2020H1NRCSentimentNames[c(1:7,9),],
       aes(x = Values,
           y = Sentiment)) +
  geom_bar(aes(fill = Sentiment),
           stat = "identity") +
  labs(title = "Front Line Workers Sentiments",
       subtitle = "First Half of 2020",
       caption = "Source: Twiiter API",
       x = "Count")




ggplot(data = frontlineTweetsFrom2020H1NRCSentimentNames[c(8,10),],
       aes(x = Values,
           y = Sentiment)) +
  geom_bar(aes(fill = Sentiment),
           stat = "identity") +
  labs(title = "Front Line Workers Sentiments",
       subtitle = "First Half of 2020",
       caption = "Source: Twiiter API",
       x = "Count")




### Second Half of 2020


frontlineTweetsFrom2020H2 <- FinalDataSetFrontLineWorkersTwitter %>% 
  select(text, created_at) %>% 
  filter(year(created_at) == 2020) %>% 
  filter(month(created_at) %in% c(07,08,09,10,11)) %>% 
  select(-created_at)





## creating tokens
Frontline2020CorpusH2 <- corpus(frontlineTweetsFrom2020H2)

Frontline2020TokensH2 <- tokens(Frontline2020CorpusH2)

Frontline2020TokensH2 <- tokens(Frontline2020TokensH2, remove_punct = TRUE, 
                                remove_numbers = TRUE)

Frontline2020TokensH2 <- tokens_select(Frontline2020TokensH2,
                                       stopwords('english'),
                                       selection='remove')


Frontline2020TokensH2 <- tokens_wordstem(Frontline2020TokensH2)

Frontline2020TokensH2 <- tokens_tolower(Frontline2020TokensH2)




# DOcument feasture matrix

Frontline2020DFMH2 <- dfm(Frontline2020TokensH2)




Frontline2020DFMH2Frequency <- textstat_frequency(Frontline2020DFMH2)


# Visualization

quanteda::textplot_wordcloud(Frontline2020DFMH2, max_words = 200, 
                             color = brewer.pal(8, "Dark2"))


Frontline2020DFMH2FrequencyLetterCloud <-
  Frontline2020DFMH2Frequency[, 1:2]

Frontline2020DFMH2FrequencyLetterCloud <-
  Frontline2020DFMH2FrequencyLetterCloud %>% 
  mutate(word = feature,
         freq = frequency)


Frontline2020DFMH2FrequencyLetterCloud <- 
  Frontline2020DFMH2FrequencyLetterCloud[, 3:4]




Frontline2020DFMH2FrequencyLetterCloudFirst200 <-
  Frontline2020DFMH2FrequencyLetterCloud[1:200,]

Frontline2020DFMH2FrequencyLetterCloudFirst500 <-
  Frontline2020DFMH2FrequencyLetterCloud[1:500,]

Frontline2020DFMH2FrequencyLetterCloudFirst1000 <-
  Frontline2020DFMH2FrequencyLetterCloud[1:1000,]




wordcloud2(Frontline2020DFMH2FrequencyLetterCloudFirst200,
           shape = "pentagon",
           size = 0.50)




wordcloud2(Frontline2020DFMH2FrequencyLetterCloudFirst500,
           color = 'random-dark',
           shape = "pentagon",
           size = 0.45)




Frontline2020DFMH2FrequencyLetterCloudFirst200


### Getting the sentiments scores



frontlineTweetsFrom2020H2String <-
  get_sentences(as.vector(frontlineTweetsFrom2020H2$text))


### getting the sentiments into parts 


frontlineTweetsFrom2020H2NRCSentiment40000 <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H2String[1:40000])



frontlineTweetsFrom2020H2NRCSentiment80000 <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H2String[40001:80000])



frontlineTweetsFrom2020H2NRCSentiment120000 <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H2String[80001:120000])



frontlineTweetsFrom2020H2NRCSentiment160000 <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H2String[120001:160000])



frontlineTweetsFrom2020H2NRCSentiment200000 <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H2String[160001:200000])



frontlineTweetsFrom2020H2NRCSentiment240000 <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H2String[200001:240000])



frontlineTweetsFrom2020H2NRCSentiment280000 <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H2String[240001:280000])



frontlineTweetsFrom2020H2NRCSentiment320000 <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H2String[280001:320000])



frontlineTweetsFrom2020H2NRCSentiment360000 <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H2String[320001:360000])



frontlineTweetsFrom2020H2NRCSentiment400000 <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H2String[360001:400000])



frontlineTweetsFrom2020H2NRCSentiment440000 <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H2String[400001:440000])



frontlineTweetsFrom2020H2NRCSentiment480000 <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H2String[440001:480000])



frontlineTweetsFrom2020H2NRCSentiment520000 <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H2String[480001:520000])



frontlineTweetsFrom2020H2NRCSentiment560000 <- 
  get_nrc_sentiment(frontlineTweetsFrom2020H2String[520001:561986])


## Putting the sentiments back together

frontlineTweetsFrom2020H2NRCSentiment <-
  frontlineTweetsFrom2020H2NRCSentiment40000

frontlineTweetsFrom2020H2NRCSentiment <-
  rbind(frontlineTweetsFrom2020H2NRCSentiment,
        frontlineTweetsFrom2020H2NRCSentiment80000)


frontlineTweetsFrom2020H2NRCSentiment <-
  rbind(frontlineTweetsFrom2020H2NRCSentiment,
        frontlineTweetsFrom2020H2NRCSentiment120000)



frontlineTweetsFrom2020H2NRCSentiment <-
  rbind(frontlineTweetsFrom2020H2NRCSentiment,
        frontlineTweetsFrom2020H2NRCSentiment160000)



frontlineTweetsFrom2020H2NRCSentiment <-
  rbind(frontlineTweetsFrom2020H2NRCSentiment,
        frontlineTweetsFrom2020H2NRCSentiment200000)



frontlineTweetsFrom2020H2NRCSentiment <-
  rbind(frontlineTweetsFrom2020H2NRCSentiment,
        frontlineTweetsFrom2020H2NRCSentiment240000)



frontlineTweetsFrom2020H2NRCSentiment <-
  rbind(frontlineTweetsFrom2020H2NRCSentiment,
        frontlineTweetsFrom2020H2NRCSentiment280000)



frontlineTweetsFrom2020H2NRCSentiment <-
  rbind(frontlineTweetsFrom2020H2NRCSentiment,
        frontlineTweetsFrom2020H2NRCSentiment320000)



frontlineTweetsFrom2020H2NRCSentiment <-
  rbind(frontlineTweetsFrom2020H2NRCSentiment,
        frontlineTweetsFrom2020H2NRCSentiment360000)



frontlineTweetsFrom2020H2NRCSentiment <-
  rbind(frontlineTweetsFrom2020H2NRCSentiment,
        frontlineTweetsFrom2020H2NRCSentiment400000)



frontlineTweetsFrom2020H2NRCSentiment <-
  rbind(frontlineTweetsFrom2020H2NRCSentiment,
        frontlineTweetsFrom2020H2NRCSentiment440000)



frontlineTweetsFrom2020H2NRCSentiment <-
  rbind(frontlineTweetsFrom2020H2NRCSentiment,
        frontlineTweetsFrom2020H2NRCSentiment480000)



frontlineTweetsFrom2020H2NRCSentiment <-
  rbind(frontlineTweetsFrom2020H2NRCSentiment,
        frontlineTweetsFrom2020H2NRCSentiment520000)


frontlineTweetsFrom2020H2NRCSentiment <-
  rbind(frontlineTweetsFrom2020H2NRCSentiment,
        frontlineTweetsFrom2020H2NRCSentiment560000)




frontlineTweetsFrom2020H2NRCSentiment

## organizing it into a data frame


FrontlineTweetsFrom2020H2NRCSentimentNames <-
  as.data.frame(names(sort(colSums(frontlineTweetsFrom2020H2NRCSentiment[,]))))

FrontlineTweetsFrom2020H2NRCSentimentValues <-
  sort(colSums(frontlineTweetsFrom2020H2NRCSentiment[,]))

FrontlineTweetsFrom2020H2NRCSentimentNames
FrontlineTweetsFrom2020H2NRCSentimentValues[[1]]



FrontlineTweetsFrom2020H2NRCSentimentValues <-
  c(FrontlineTweetsFrom2020H2NRCSentimentValues[[1]],
    FrontlineTweetsFrom2020H2NRCSentimentValues[[2]],
    FrontlineTweetsFrom2020H2NRCSentimentValues[[3]],
    FrontlineTweetsFrom2020H2NRCSentimentValues[[4]],
    FrontlineTweetsFrom2020H2NRCSentimentValues[[5]],
    FrontlineTweetsFrom2020H2NRCSentimentValues[[6]],
    FrontlineTweetsFrom2020H2NRCSentimentValues[[7]],
    FrontlineTweetsFrom2020H2NRCSentimentValues[[8]],
    FrontlineTweetsFrom2020H2NRCSentimentValues[[9]],
    FrontlineTweetsFrom2020H2NRCSentimentValues[[10]])



FrontlineTweetsFrom2020H2NRCSentimentNames$Values <- 
  FrontlineTweetsFrom2020H2NRCSentimentValues



FrontlineTweetsFrom2020H2NRCSentimentNames <-
  FrontlineTweetsFrom2020H2NRCSentimentNames %>% 
  transmute(Sentiment = `names(sort(colSums(frontlineTweetsFrom2020H2NRCSentiment[, ])))`,
            Values = Values)



FrontlineTweetsFrom2020H2NRCSentimentNames


# visualizing


ggplot(data = FrontlineTweetsFrom2020H2NRCSentimentNames[1:8,],
       aes(x = Values,
           y = Sentiment)) +
  geom_bar(aes(fill = Sentiment),
           stat = "identity") +
  labs(title = "Front Line Workers Sentiments",
       subtitle = "Second Half of 2020",
       caption = "Source: Twiiter API",
       x = "Count")


ggplot(data = FrontlineTweetsFrom2020H2NRCSentimentNames[9:10,],
       aes(x = Values,
           y = Sentiment)) +
  geom_bar(aes(fill = Sentiment),
           stat = "identity") +
  labs(title = "Front Line Workers Sentiments",
       subtitle = "Second Half of 2020",
       caption = "Source: Twiiter API",
       x = "Count")




## Comparing the 3 periods




FrontlineBefore2020NRCSentimentNames



sum(FrontlineBefore2020NRCSentimentNames[1:8,2])


sum(FrontlineBefore2020NRCSentimentNames[9:10,2])






frontlineTweetsFrom2020H1NRCSentimentNames


sum(frontlineTweetsFrom2020H1NRCSentimentNames[c(1:7,9),2])



sum(frontlineTweetsFrom2020H1NRCSentimentNames[c(8,10),2])





FrontlineTweetsFrom2020H2NRCSentimentNames



sum(FrontlineTweetsFrom2020H2NRCSentimentNames[1:8,2])



sum(FrontlineTweetsFrom2020H2NRCSentimentNames[9:10,2])



#Proportion test before and on 2020 h1

#trust


prop.test(c(11397, 25515), c(54030, 149698), alternative = "greater")

#fear


prop.test(c(7012, 23474), c(54030, 149698), alternative = "less")

#anger


prop.test(c(5150, 15722), c(54030, 149698), alternative = "less")



#sadness


prop.test(c(5855, 19105), c(54030, 149698), alternative = "less")

#surprise



prop.test(c(4175, 10776), c(54030, 149698), alternative = "greater")


#joy



prop.test(c(7868, 19928), c(54030, 149698), alternative = "greater")


##Negative


prop.test(c(11390, 34778), c(28744, 79052), alternative = "less")


#positive



prop.test(c(17354, 44274), c(28744, 79052), alternative = "greater")



##before and h2

#disugust


prop.test(c(63752, 12364), c(816241, 149698), alternative = "less")



#surprise

prop.test(c(70471, 10776), c(816241, 149698), alternative = "greater")



#anger

prop.test(c(89079, 15722), c(816241, 149698), alternative = "greater")



#sadness


prop.test(c(93613, 19105), c(816241, 149698), alternative = "less")



#joy



prop.test(c(106578, 19928), c(816241, 149698), alternative = "less")




#Fear

prop.test(c(106590, 23474), c(816241, 149698), alternative = "less")




#Abtecipation


prop.test(c(123854, 22814), c(816241, 149698), alternative = "less")



#Trust


prop.test(c(162304, 25515), c(816241, 149698), alternative = "greater")





#NEgative

prop.test(c(188337, 34778), c(816241, 149698), alternative = "less")



#POtive


prop.test(c(243715, 44274), c(816241, 149698), alternative = "greater")




## h1 and h2


#disgust


prop.test(c(63752, 3888), c(816241, 54630), alternative = "greater")



#surprise

prop.test(c(70471, 4175), c(816241, 54630), alternative = "greater")



#anger

prop.test(c(89079, 5150), c(816241, 54630), alternative = "greater")




#sadness


prop.test(c(93613, 5855), c(816241, 54630), alternative = "greater")



#joy



prop.test(c(106578, 7868), c(816241, 54630), alternative = "less")




#Fear

prop.test(c(106590, 7012), c(816241, 54630), alternative = "greater")




#Abtecipation


prop.test(c(123854, 8685), c(816241, 54630), alternative = "less")




#Trust


prop.test(c(162304, 11397), c(816241, 54630), alternative = "less")





##NEgative

prop.test(c(188337, 11390), c(816241, 28744), alternative = "less")



#POtive


prop.test(c(243715, 17354), c(816241, 28744), alternative = "less")





################################################################################


## Association Rules



## getting the data from the target sample of the frontline workers


targetSampleOfFrontLineWorkers


## target sample only text


targetSampleOfFrontLineWorkersTweets <-
  targetSampleOfFrontLineWorkers$text



## getting the corpus and producing the tokens


targetSampleOfFrontLineWorkersTweetsCorpus <- corpus(targetSampleOfFrontLineWorkersTweets)

targetSampleOfFrontLineWorkersTweetsTokens <- tokens(targetSampleOfFrontLineWorkersTweetsCorpus)

targetSampleOfFrontLineWorkersTweetsTokens <- tokens(targetSampleOfFrontLineWorkersTweetsTokens, remove_punct = TRUE, 
                                                     remove_numbers = TRUE)

targetSampleOfFrontLineWorkersTweetsTokens <- tokens_select(targetSampleOfFrontLineWorkersTweetsTokens,
                                                            stopwords('english'),
                                                            selection='remove')


targetSampleOfFrontLineWorkersTweetsTokens <- tokens_wordstem(targetSampleOfFrontLineWorkersTweetsTokens)

targetSampleOfFrontLineWorkersTweetsTokens <- tokens_tolower(targetSampleOfFrontLineWorkersTweetsTokens)



## Creating the document feature matrix

targetSampleOfFrontLineWorkersTweetsDFM <- dfm(targetSampleOfFrontLineWorkersTweetsTokens)



targetSampleOfFrontLineWorkersTweetsDFMDataFrame <-
  as.data.frame(targetSampleOfFrontLineWorkersTweetsDFM)






targetSampleOfFrontLineWorkersTweetsDFMDataFrame <-
  targetSampleOfFrontLineWorkersTweetsDFMDataFrame %>%
  select(-doc_id) 

## Transforming the zeros and ones into a factor of two levels No and Yes


for(i in 1:length(names(targetSampleOfFrontLineWorkersTweetsDFMDataFrame))){
  targetSampleOfFrontLineWorkersTweetsDFMDataFrame[,i] <- as.character(targetSampleOfFrontLineWorkersTweetsDFMDataFrame[,i])
  
  targetSampleOfFrontLineWorkersTweetsDFMDataFrame[,i] <-
    factor(targetSampleOfFrontLineWorkersTweetsDFMDataFrame[,i],
           levels = c("0", "1"),
           labels = c("No", "Yes"))
}




targetSampleOfFrontLineWorkersTweetsDFMDataFrame


## Getting the frequency of each word


textstat_frequency(targetSampleOfFrontLineWorkersTweetsDFM)


## Checking if the levels are okay


contrasts(targetSampleOfFrontLineWorkersTweetsDFMDataFrame$find)





## APriori Rules for all the words


#Min support 1%, min confidence 50%
rules <-  apriori(targetSampleOfFrontLineWorkersTweetsDFMDataFrame, parameter = list(support= .01, confidence = .5))


# There are 26679202 rules 
inspect(rules)



summary(rules)



## Visualizing

#Plot the rules
plot(rules)



## Top Confidence Rules

#Extract top 5 lift rules
top5Confidence <- head(sort(rules, by = "confidence", decreasing = TRUE), 5)


## Top Lift Rules

#Extract top 5 lift rules
top5lift <- head(sort(rules, by = "lift"), 5)


#Extract top 10 lift rules
top10lift <- head(sort(rules, by = "lift"), 10)



#Extract top 20 lift rules
top20lift <- head(sort(rules, by = "lift"), 20)


## Visualization

plot(top5lift, method = "graph")



plot(top5lift)


plot(top10lift, method = "graph")



plot(top10lift)



plot(top20lift, method = "graph")



plot(top20lift)



# Performing rules with more specific criteria with "nurs"



rules2 <-  apriori(targetSampleOfFrontLineWorkersTweetsDFMDataFrame, parameter = list(support= 0.1, confidence = 0.5),
                   appearance = list(rhs = c("nurs=Yes"), default = "lhs"))


inspect(rules2)


#Extract top 5 lift rules
top20lift2 <- head(sort(rules2, by = "lift"))





plot(top20lift2, method = "graph")



# Performing rules with more specific criteria with "work"



rules4 <-  apriori(targetSampleOfFrontLineWorkersTweetsDFMDataFrame, parameter = list(support= 0.1, confidence = 0.5),
                   appearance = list(rhs = c("work=Yes"), default = "lhs"))



#Extract top 5 lift rules
top20lift4 <- head(sort(rules4, by = "lift"))




plot(top20lift4, method = "graph")









################################################################################


## Time Series and Non Linear regression



## Producing the time series analysis


FinalDataSetFrontLineWorkersTwitter



# for the tweets




TimeSeriesFinalDataSet <- 
  FinalDataSetFrontLineWorkersTwitter %>%
  select(created_at)




TimeSeriesFinalDataSet$created_at <-
  format(as.Date(TimeSeriesFinalDataSet$created_at), "%Y-%m")





TimeSeriesFinalDataSet <- TimeSeriesFinalDataSet %>%
  group_by(created_at) %>%
  summarise(count = n())



TimeSeriesFinalDataSet 



length(TimeSeriesFinalDataSet$created_at)



# excluding one observation that are out of of the order

TimeSeriesFinalDataSet <-
  TimeSeriesFinalDataSet[2:133,]




length(TimeSeriesFinalDataSet$created_at)



TimeSeriesFinalDataSet


## Producing the Time series object

TimeSeriesFinalDataSetTS <- ts(TimeSeriesFinalDataSet$count,
                               frequency = 12, start = c(2009, 8))




TimeSeriesFinalDataSetTSDecomposed <- decompose(TimeSeriesFinalDataSetTS, type="additive")
TimeSeriesFinalDataSetTSstl <- stl(TimeSeriesFinalDataSetTS, s.window = "periodic")
plot (TimeSeriesFinalDataSetTSDecomposed, type="o", col="red", lty="dashed")





TimeSeriesFinalDataSetTSModel <-
  auto.arima(TimeSeriesFinalDataSetTS)




TimeSeriesFinalDataSetTSPrediction <-
  forecast(TimeSeriesFinalDataSetTSModel, 
           h = 6)



TimeSeriesFinalDataSetTSPrediction



plot(TimeSeriesFinalDataSetTSPrediction)



accuracy(TimeSeriesFinalDataSetTSModel)




# for the accounts




TimeSeriesFinalDataSetAccounts <- 
  FinalDataSetFrontLineWorkersTwitter %>%
  select(account_created_at)



TimeSeriesFinalDataSetAccounts



TimeSeriesFinalDataSetAccounts <- TimeSeriesFinalDataSetAccounts %>%
  group_by(account_created_at) %>%
  summarise(count = n())


TimeSeriesFinalDataSetAccounts






TimeSeriesFinalDataSetAccounts$account_created_at <-
  format(as.Date(TimeSeriesFinalDataSetAccounts$account_created_at), "%Y-%m")




TimeSeriesFinalDataSetAccounts <- TimeSeriesFinalDataSetAccounts %>%
  group_by(account_created_at) %>%
  summarise(count = n())




TimeSeriesFinalDataSetAccounts 



length(TimeSeriesFinalDataSetAccounts$account_created_at)





# excluding one observation that is out of of the order
TimeSeriesFinalDataSetAccounts <-
  TimeSeriesFinalDataSetAccounts[4:149,]




length(TimeSeriesFinalDataSetAccounts$account_created_at)


TimeSeriesFinalDataSetAccounts


## creating the time series object

TimeSeriesFinalDataSetAccountsTS <- ts(TimeSeriesFinalDataSetAccounts$count,
                                       frequency = 12, start = c(2008, 10))


## Plotting the decomposition

TimeSeriesFinalDataSetAccountsTSDecomposed <- decompose(TimeSeriesFinalDataSetAccountsTS, type="additive")

TimeSeriesFinalDataSetAccountsTSstl <- stl(TimeSeriesFinalDataSetAccountsTS, s.window = "periodic")

plot (TimeSeriesFinalDataSetAccountsTSDecomposed, type="o", col="red", lty="dashed")



## Building the model

TimeSeriesFinalDataSetAccountsTSModel <-
  auto.arima(TimeSeriesFinalDataSetAccountsTS)


## Forecasting

TimeSeriesFinalDataSetAccountsTSPrediction <-
  forecast(TimeSeriesFinalDataSetAccountsTSModel, h = 6)



plot(TimeSeriesFinalDataSetAccountsTSPrediction)




TimeSeriesFinalDataSetAccountsTSPrediction



## Getting the accuracies

accuracy(TimeSeriesFinalDataSetAccountsTSModel)




#### Non linear regression ###


## getting the cumulative accounts

TimeSeriesFinalDataSetAccounts




TimeSeriesFinalDataSetAccountsCumulative <-
  as.vector(cumsum(TimeSeriesFinalDataSetAccounts$count))



TimeSeriesFinalDataSetAccountsCumulative <-
  TimeSeriesFinalDataSetAccountsCumulative[29:146]




TimeSeriesFinalDataSetAccountsCumulative <-
  as.data.frame(TimeSeriesFinalDataSetAccountsCumulative)



## getting the cumulative tweets


TimeSeriesFinalDataSet




TimeSeriesFinalDataSetCumulative <-
  as.vector(cumsum(TimeSeriesFinalDataSet$count))



TimeSeriesFinalDataSetCumulative <- TimeSeriesFinalDataSetCumulative[15:132]



TimeSeriesFinalDataSetCumulative <-
  as.data.frame(TimeSeriesFinalDataSetCumulative)




TimeSeriesFinalDataSetTweetsAccountsCumulative<- 
  cbind(TimeSeriesFinalDataSetAccountsCumulative,
        TimeSeriesFinalDataSetCumulative)


## final data set

TimeSeriesFinalDataSetTweetsAccountsCumulative



## obsering if the variaables have a nonlinear correlation


pairs(TimeSeriesFinalDataSetTweetsAccountsCumulative)


## constructing the models

#Loess Method




TimeSeriesFinalDataSetTweetsAccountsCumulativeLoessModel <- loess( TimeSeriesFinalDataSetCumulative ~ TimeSeriesFinalDataSetAccountsCumulative, data = TimeSeriesFinalDataSetTweetsAccountsCumulative)

summary(TimeSeriesFinalDataSetTweetsAccountsCumulativeLoessModel)



TimeSeriesFinalDataSetTweetsAccountsCumulative



TimeSeriesFinalDataSetTweetsAccountsCumulative$PredictedTweets <-
  predict(TimeSeriesFinalDataSetTweetsAccountsCumulativeLoessModel,TimeSeriesFinalDataSetTweetsAccountsCumulative$TimeSeriesFinalDataSetAccountsCumulative)



loessMSE <-
  mse(TimeSeriesFinalDataSetTweetsAccountsCumulative$TimeSeriesFinalDataSetAccountsCumulative,
      TimeSeriesFinalDataSetTweetsAccountsCumulative$PredictedTweets)
loessMSE


loessMAE <-
  mae(TimeSeriesFinalDataSetTweetsAccountsCumulative$TimeSeriesFinalDataSetAccountsCumulative,
      TimeSeriesFinalDataSetTweetsAccountsCumulative$PredictedTweets)
loessMAE


loessRMSE <-
  rmse(TimeSeriesFinalDataSetTweetsAccountsCumulative$TimeSeriesFinalDataSetAccountsCumulative,
       TimeSeriesFinalDataSetTweetsAccountsCumulative$PredictedTweets)
loessRMSE



## Visualizing the model

ggplot(data = TimeSeriesFinalDataSetTweetsAccountsCumulative,
       mapping = aes(x =TimeSeriesFinalDataSetCumulative,
                     y = TimeSeriesFinalDataSetAccountsCumulative)) +
  geom_smooth() +
  labs(title = "Correlation Between Comulative Numbers",
       subtitle = "Account VS Tweets",
       y = "Number of Accounts",
       x = "Number of Tweets",
       caption = "Source: Twitter API")
 



