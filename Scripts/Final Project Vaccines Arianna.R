---
  title: "R Notebook"
output: html_notebook
---

  # Install Packages 
  
install.packages("tidyverse")
install.packages("rtweet")
install.packages("stringr")
install.packages("tm")
install.packages("quanteda")
install.packages("RColorBrewer")
install.packages("syuzhet")
install.packages("rpart")
install.packages("caTools")
install.packages("e1071")
install.packages("quanteda")
install.packages("caret")

library(tidyverse)
library(syuzhet)
library(rpart)
library(caTools)
library(e1071)
library(quanteda)
library(caret)
require(caret)
library(tidyverse)
library(rtweet)
library(stringr)
library(tm)
library(quanteda)
library(RColorBrewer)

# Keys
api_key <- "3PLkQqyCiA7JJzBmHIyvBbfQs"
api_secret_key <- "aQ07k7OFHnfcyUEI9kZwf01i4rlsy2fMH22SjMEG6yuf2l4Ply"
access_token <- "179776303-dpOM5ZJm3az3UJ8ehG3AoXaFMMIvEj9SSUFErfS9"
acces_token_secret <- "wDofi7G2xKDG6ovFU08bEBk2v8iS7VJJ48qs1Czq6mTuk"

token<- create_token ( 
  app = "ProjectTwitterCISR",
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = acces_token_secret)

# Extract General Dataset with Vaccine related tweets

covidvaccine <- search_tweets("vaccine|#vaccine", n = 100000, include_rts = FALSE)
view(covidvaccine)

# Select the Columns we need for the Analysis

vaccinetext<- select(covidvaccine, screen_name, text, quoted_location)

# Remove Duplicate Users

unique(vaccinetext, incomparables = FALSE, fromLast = FALSE,
       nmax = NA)
view(vaccinetext)

#Save giant data set into csv



tibble_with_lists_to_csv <- function(tibble_object, file_path_name) {
  set_lists_to_chars <- function(x) { 
    if(class(x) == 'list') { y <- paste(unlist(x[1]), sep='', collapse=', ') } else { y <- x  } 
    return(y) }
  new_frame <- data.frame(lapply(tibble_object, set_lists_to_chars), stringsAsFactors = F)
  write.csv(new_frame, file=file_path_name)
}

# change to new data set name 
tibble_with_lists_to_csv(covidvaccine, "covidvaccine.csv")


#Use Corpus to find most used words 

vaccinecorpus <- Corpus(VectorSource(vaccinetext$text))
vaccineTDM <- TermDocumentMatrix(vaccinecorpus)


tdm <- as.matrix(vaccineTDM)
tdm[1:10, 1:20]

#Bar Plot
w<- row_sums(tdm)
w <- subset(w,w>=25)
barplot(w, las = 2, col = rainbow(50))

vaccinematrix<- inspect(vaccineTDM)
view(vaccinematrix)


install.packages("wordcloud")
library("wordcloud")
wordcloud(vaccinecorpus)

#Document FeatureMAtrix (DFM)

tweetDFM <- dfm(vaccinetext$text,
                remove_punct = TRUE,
                remove = stopwords("english"))

tweet_rt7 <- as.tibble(tweetDFM)
tweet_rt7


#TOP Features

topfeaturesvaccine <- topfeatures(tweetDFM)
view(topfeaturesvaccine)

text_frequency<- textstat_frequency(tweetDFM)
view(text_frequency)


# Semantic Differential Adjectives:

# Excited vs Scared

# Happy vs mad

# Good vs Bad

# Safe vs Dangerous 

# Hopeful vs Hesitant





# Extract tweets with positive feelings and mutate a new column with the feeling 

view(vaccinetext)

#Excited

excitedstr<- vaccinetext %>% filter(str_detect(text,"excited"))
excitedonly<- excitedstr %>% filter(!str_detect(text,("happy|good|hopeful|safe|bad|scared|hesitant|mad|dangerous")))                                                    bad|dangerous|hesitant|mad")))
excited <- excitedonly %>% mutate(feeling = "Excited")
view(excited)

# Happy 

happystr<- vaccinetext %>% filter(str_detect(text,"happy")) 
happyonly<- happystr %>% filter(!str_detect(text,("excited|good|hopeful|safe|bad|scared|hesitant|mad|dangerous")))
happy <- happyonly %>% mutate(feeling = "Happy")
view(happy)

# Good 
goodstr<- vaccinetext %>% filter(str_detect(text,"good"))
goodonly<- goodstr %>% filter(!str_detect(text,("happy|excited|hopeful|safe|bad|scared|hesitant|mad|dangerous")))
good <- goodonly %>% mutate(feeling = "Good")
view(good)

# Hopeful

hopefulstr<- vaccinetext %>% filter(str_detect(text,"hopeful")) 
hopefulonly<- hopefulstr %>% filter(!str_detect(text,("excited|good|happy|safe|bad|scared|hesitant|mad|dangerous")))
hopeful <- hopefulonly %>% mutate(feeling = "Hopeful")
view(hopeful)

# Safe 

safestr<- vaccinetext %>% filter(str_detect(text,"safe")) 
safeonly<- safestr %>% filter(!str_detect(text,("excited|good|happy|hopeful"))) 
safe <- safeonly %>% mutate(feeling = "Safe")
view(safe)



#Rbind all of them together

PositiveFeeling<- rbind(happy, good, hopeful, excited, safe)
View(PositiveFeeling)

# Extract tweets with semantical opposite feelings 

# Scared
scaredstr<- vaccinetext %>% filter(str_detect(text,scared"))
scaredonly<- scaredstr %>% filter(!str_detect(text,("bad|dangerous|hesitant|mad|happy|excited|hopeful|safe|good")))
scared <- scaredonly %>% mutate(feeling = "Scared")
view(scared)

# Mad

madstr<- vaccinetext %>% filter(str_detect(text,"mad")) 
madonly<- madstr %>% filter(!str_detect(text,("bad|dangerous|hesitant|scared|happy|excited|hopeful|safe|good"))) 
mad <- madonly %>% mutate(feeling = "Mad")
view(mad)

# Bad

badstr<- vaccinetext %>% filter(str_detect(text,"bad"))
badonly<- badstr %>% filter(!str_detect(text,("mad|dangerous|hesitant|scared|happy|excited|hopeful|safe|good")))
bad <- badonly %>% mutate(feeling = "Bad")
view(bad)

# Hesitant 

hesitantstr<- vaccinetext %>% filter(str_detect(text,"hesitant")) 
hesitantonly<- hesitantstr %>% filter(!str_detect(text,("mad|dangerous|bad|scared|happy|excited|hopeful|safe|good")))
hesitant <- hesitantonly %>% mutate(feeling = "Hesitant")
view(hesitant)

# Dangerous 

dangerousstr<- vaccinetext %>% filter(str_detect(text,"dangerous"))
dangerousonly<- dangerousstr %>% filter(!str_detect(text,("bad|scared|hesitant|mad|happy|excited|hopeful|safe|good")))
dangerous <- dangerousonly %>% mutate(feeling = "Dangerous")
view(dangerous)



#Rbind all of them together

NegativeFeeling<- rbind(scared, mad, bad, hesitant, dangerous)
view(NegativeFeeling)


# Mutate Positive Feelings with new Column:

PositiveFeeling <- PositiveFeeling %>% mutate(sentiment = "1")

NegativeFeeling <- NegativeFeeling %>% mutate(sentiment = "0")


# Rbind Positive and Negative 



Sentiment <- rbind(PositiveFeeling, NegativeFeeling)
view(Sentiment)


# Downlad as CSV 

tibble_with_lists_to_csv <- function(tibble_object, file_path_name) {
  set_lists_to_chars <- function(x) { 
    if(class(x) == 'list') { y <- paste(unlist(x[1]), sep='', collapse=', ') } else { y <- x  } 
    return(y) }
  new_frame <- data.frame(lapply(tibble_object, set_lists_to_chars), stringsAsFactors = F)
  write.csv(new_frame, file=file_path_name)
}


# change to new data set name 
tibble_with_lists_to_csv(Sentiment, "Sentiment.csv")


# Positive Count


count(Sentiment, feeling == "Happy")
count(Sentiment, feeling == "Good")
count(Sentiment, feeling == "Excited")
count(Sentiment, feeling == "Hopeful")
count(Sentiment, feeling == "Safe")

# Negative Count 

count(Sentiment, feeling == "Scared")
count(Sentiment, feeling == "Mad")
count(Sentiment, feeling == "Bad")
count(Sentiment, feeling == "Hesitant")
count(Sentiment, feeling == "Dangerous")

View(Sentiment)





# Visualization Positive

ggplot(data = PositiveFeeling,
       aes(x = feeling,
           y = sentiment)) +
  geom_bar(aes(fill = feeling),
           stat = "identity") +
  labs(title = "Vaccine Positive Feelings",
       caption = "Source: Twitter API",
       x = "Count")

# Visualization Negative


ggplot(data = NegativeFeeling,
       aes(x = feeling,
           y = sentiment)) +
  geom_bar(aes(fill = feeling),
           stat = "identity") +
  labs(title = "Vaccine Negative Feelings",
       caption = "Source: Twitter API",
       x = "Count")

# Visualization Sentiments Positive and Negative

ggplot(data = Sentiment,
       aes(x = sentiment, y = )
  
  geom_bar(aes(fill = feeling),
           stat = "identity"))
  labs(title = "Vaccine Sentiments",
       caption = "Source: Twiiter API",
       x = "Count")

# Visualization Positive Vs Negative 

ggplot(data = Sentiment,
       aes(x = sentiment,
           y = feeling)) +
  geom_boxplot(aes(fill = feeling),
           stat = "identity") +
  theme(axis.text.y = element_text(angle= 90, hjust = 1))
  labs(title = "Vaccine Sentiments",
       caption = "Source: Twiiter API",
       x = "Sentiment")
  
  
  # Vaccine Analysis II
  
  # 1 get data set sentiment 
  
  <dataset> %>% filter(sentiment == "happy") %>% select(text)
  
  
  vaccinetext<- select(vaccinetext, screen_name, text, quoted_location)
  
  textonly<- select(vaccinetext, text)
  
  tweetsonlyvaccine <-
    get_sentences(as.vector(textonly$text))

  

  tweetsonlyvaccine

  
 
  tweetsonlyvaccinesentiment <- 
    get_nrc_sentiment(tweetsonlyvaccine)

  tweetsonlyvaccinesentiment

  vaccinefeelingtest <- tweetsonlyvaccinesentiment %>% mutate(ispositive = ifelse(positive> 0, "Yes", "No"))
  vaccinefeelingtest
  vaccinefeelingtest <- vaccinefeelingtest %>% mutate(isnegative = ifelse(negative> 0, "Yes", "No"))
  vaccinefeelingtest

  vaccinefeelingtest$classification <- c(as.vector(vaccinefeelingtest$positive)-as.vector(vaccinefeelingtest$negative))
  vaccinefeelingtest
  vaccinefeelingtest <- vaccinefeelingtest %>% mutate(classification = ifelse(classification >0, "Positive", ifelse(classification== 0, "Neutral", "Negative")))
  vaccinefeelingtest
 
  #Filter out the neutral classification
 
  vaccinefeelingtestfiltered <- vaccinefeelingtest%>% filter (classification == c("Positive", "Negative")) 
  
  #Select what we need only, taking our Neutral Phrases
  vaccinefeel <- select(vaccinefeelingtestfiltered,anger, anticipation, disgust,fear, joy, sadness, surprise, trust,classification   )
  vaccinefeel
 
  
  
  # Naive Bayes Model 
  
  # Convert to factors
  
  
  # Separate into two data sets
 
  feelingsonlysep <- select(vaccinefeel, anger, anticipation, disgust,fear, joy, sadness, surprise, trust)
  feelingsonlysep
  
  classificationonly <- select(vaccinefeel, classification)
  classificationonly
  ```
  #

  for(i in 1:length(names(feelingsonlysep))){
    feelingsonlysep[,i] <- as.character(feelingsonlysep[,i])
    
    feelingsonlysep[,i] <-
      factor(feelingsonlysep[,i],
             labels = c("0", "1"),
             levels = c("0", "1"))
  }

  
  #Cbind them together
  
  vaccinefeel2<- cbind(feelingsonlysep, classificationonly)
  vaccinefeel2
  
 
  head(vaccinefeel2)
  ```
  

  vaccinefeel2$Succesful <- as.factor(ifelse(vaccinefeel2$classification == c("Positive","Negative"), "Yes","No"))
  
  
  #Sample 
  
  #require(caTools)
  
  set.seed(123)
  
  #Split Data
  SampleV <- sample.split(vaccinefeel2$classification, SplitRatio = .75)
  
  
  trainv <- filter(vaccinefeel2, SampleV == TRUE)
  testv <- filter(vaccinefeel2, SampleV== FALSE)

  #Given the User Feelings, will the tweet have a positive or negative sentiment?
  

  # Naive Bayes Model
  vaccinemodel <- naiveBayes(Succesful ~ anger + anticipation + disgust + fear + joy + sadness + surprise + trust, data = trainv)
  vaccinemodel

  
  # Predict Class

  # Perform on the testing set
  
  predictionv <- predict(vaccinemodel, testv, type = "class")
  predictionv
  
  table (testv$Succesful, predictionv, dnn = c ("Actual", "Prediction"))
  
  vaccinedataframe<- data.frame(testv, Prediction = predictionv)
  vaccinedataframe
  

  
  # Predict Probability of Classes with the Model 
  
  
  predictionprob <- predict(vaccinemodel, testv, type = "raw")
  
  result_prob <- data.frame(Actual = testv$Succesful,
                            PredictionClass = predictionv,
                            Prediction = predictionprob)
  result_prob

  
  # Calculate Accurracy 
  
 
  # Extract TP + TN
  
  TPTN <- nrow(subset(result_prob, Actual == PredictionClass))
  
  #Get the size of the testing set
  
  testSize <- nrow(testv)
  
  #CalculateAccurracy
  
  accurracy <- TPTN/ testSize
  cat ("Naive Bayes Classifier Accurracy", accurracy)

  
  # La Place 5 

  vaccinemodelplace1 <- naiveBayes(Succesful ~ anger + anticipation + disgust + fear + joy + sadness + surprise + trust, data = trainv, laplace =5)
  
  
  laplaceprediction <- predict(vaccinemodelplace1, testv, type= "class") 
  
  laplaceresult <- data.frame(Actual = testv$Succesful, Prediction = laplaceprediction)
  
  accuratevaccine <- subset(laplaceresult, Actual == Prediction)
  
  laplaceaccurracy <- nrow(accuratevaccine)/nrow(testv)
  laplaceaccurracy
  ```
  
  
  
  
  # Visualizations 
  
  

  as.factor(tweetsonlyvaccinesentiment)

  

  tweetsonlyvaccinesentimentnames <-
    as.data.frame(names(sort(colSums(tweetsonlyvaccinesentiment[,]))))
  
  tweetsonlyvaccinesentimentvalues <-
    sort(colSums(tweetsonlyvaccinesentiment[,]))

  tweetsonlyvaccinesentimentvalues <-
    c(tweetsonlyvaccinesentimentvalues[[1]],
      tweetsonlyvaccinesentimentvalues[[2]],
      tweetsonlyvaccinesentimentvalues[[3]],
      tweetsonlyvaccinesentimentvalues[[4]],
      tweetsonlyvaccinesentimentvalues[[5]],
      tweetsonlyvaccinesentimentvalues[[6]],
      tweetsonlyvaccinesentimentvalues[[7]],
      tweetsonlyvaccinesentimentvalues[[8]],
      tweetsonlyvaccinesentimentvalues[[9]],
      tweetsonlyvaccinesentimentvalues[[10]])
  
  
  tweetsonlyvaccinesentimentnames$Values <- 
    tweetsonlyvaccinesentimentvalues
  
  
  
  tweetsonlyvaccinesentimentnames <-
    tweetsonlyvaccinesentimentnames %>% 
    transmute(Sentiment = `names(sort(colSums(tweetsonlyvaccinesentiment[, ])))`,
              Values = Values)

  ggplot(data = tweetsonlyvaccinesentimentnames[c(1:8),],
         aes(x = Values,
             y = Sentiment)) +
    geom_bar(aes(fill = Sentiment),
             stat = "identity") +
    labs(title = "Vaccine Sentiments",
         caption = "Source: Twiiter API",
         x = "Count")
  
  ggplot(data = tweetsonlyvaccinesentimentnames[c(9,10),],
         aes(x = Values,
             y = Sentiment)) +
    geom_bar(aes(fill = Sentiment) ,
             stat = "identity") +
    labs(title = "Vaccine Sentiments",
         caption = "Source: Twiiter API",
         x = "Count")

  
  # Logistic Regression 
  
  

  
  # Non linear Regression 
  
  
  #Loess Method
  
  # Is there a relationshop between the user followers and user retweets in vaccine related tweets? Does the number of followers impact the number of retweets?
  
  
  

  
  vaccine_loess <- covidvaccine %>% 
    
    select(quoted_followers_count, quoted_retweet_count)
  
  vaccine_loess <- na.omit(vaccine_loess)
  vaccine_loess
  
  # Training and Testing set
  set.seed(123)
  
  
  sampleloess2 <- sample.split(vaccine_loess$quoted_followers_count, SplitRatio = .75)
  
  sampleloess2 
  
  trainloess <- subset(vaccine_loess, sampleloess2 == TRUE)
  testloess <- subset(vaccine_loess, sampleloess2== FALSE)
  
  vaccineloessretweets <- loess( quoted_retweet_count ~ quoted_followers_count, data = trainloess)
  vaccineloessretweets
  summary(vaccineloessretweets)

  #Prediction with Loess
  ##What would be the user retweets when the user followers are 1000?
  
 
  
  predictionofretweets <- data.frame(quoted_followers_count   = c(1000))
  predictedpositionofretweets <- predict(vaccineloessretweets,predictionofretweets)
  cat("At 1000 user followers, the retweets count is", predictedpositionofretweets )
  
  # Predict the testing set 
  
  # Predict the position with the model and test data
  
  predictedRetweets <- predict (vaccineloessretweets, testloess)
  predictedRetweets
  
  # Create a data frame with actual and predicted values
  
  loessprediction <- data.frame(quoted_followers_count = testloess$quoted_followers_count,
                                ActualRetweets = testloess$quoted_retweet_count,
                                PredictedRetweets =predictedRetweets )
  loessprediction
  
  
  # Visualize: Scatter plot Visualize the prediction
  
  ggplot (data = loessprediction, mapping = aes (x = log(quoted_followers_count))) + 
    geom_point(data = loessprediction, 
               mapping = aes(y = log(ActualRetweets)), color = "blue")+ geom_point(data = loessprediction, mapping = aes( y = PredictedRetweets), color = "red") 
  
  # Test for Correlation 
  
  # PairsPlot
  
  rtfollowers <- select(covidvaccine, c("quoted_retweet_count", "quoted_followers_count"))
  pairs(rtfollowers)
  
  rtfol <- cor(covidvaccine$quoted_retweet_count, covidvaccine$quoted_followers_count)
  rtfol
  
  
  # Visualize the non linear regression
  
  ggplot(data = vaccine_loess, mapping = aes(x = log(quoted_retweet_count), y = log(quoted_followers_count)  )) +
    geom_point(alpha = 0.25)+
    geom_smooth(method = "loess") +
    labs(title = "User Followers vs User Retweets",
         subtitle = "Loess Model Method",
         x = "User Retweet Count",
         y = "User Followers Count"
    )

  