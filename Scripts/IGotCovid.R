---
  title: "Project CIS 543"
output: html_notebook
---
  Sentimental analysis


```{r}
##install rtweet from CRAN
#install.packages("rtweet")
install.packages("syuzhet")
install.packages("scales")
install.packages("reshape2")
```

```{r}
library(rtweet)
library(tidyverse)
library(lubridate)
library(stringr)
library(tm)
library(quanteda)
library(reshape2)
library(lda)
```

```{r}
##API keys )
api_key <- "V7lOlFIVOfs1uPHP5ZbihmHiz"
api_secret_key <- "YYyO26mVGqZhJIe59OkiEMmzUewOuGV9OkzpREgAm68CM1zAGy"
access_token <- "1326316127119699969-oqLkYSNsP8UwzFH3TCIjeIz3hTPzbh"
access_token_secret <- "16H5Kyyiy8as1jW7ZDXIy0nEyASXCfYHtBEQOCqZVt1gi"


## autenticate via WEB browser
token <- create_token(
  app = "RaulTextAnalysis",
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = access_token_secret)
```

##Seach for #### tweets using the rstats hashtag####
```{r}
ct <- search_tweets(q = "\"I have COVID\" OR \"I tested positive for COVID\" AND
                     -filter:verified AND 
                     -filter:news",
                    n = 15000, include_rts = FALSE )

```

```{r}
min(ct$created_at)
```

```{r}
head(ct)
```


```{r}
ct_Covid <- sum(str_detect(ct$text, regex( "I have Covid", ignore_case = TRUE)))

cat("Number of tweets with 'I have Covid':",ct_Covid, "\n")

ct_Covid <- sum(str_detect(ct$text,regex("positive", ignore_case = TRUE)))

cat("Number of tweets with 'I test positive':",ct_Covid,"\n")

ct_Covid <- sum(str_detect(ct$text, regex("symptoms", ignore_case = TRUE)))

cat("Number of tweets with 'I got symptoms':",ct_Covid)
```


```{r}
ct_Courpus <- Corpus(VectorSource(ct$text))
```

#Clean the data
```{r}
ct_Courpus <- tm_map(ct_Courpus, tolower)
ct_Courpus <- tm_map(ct_Courpus, removePunctuation)
ct_Courpus <- tm_map(ct_Courpus, removeNumbers)
inspect(ct_Courpus[1:10])
```
```{r}
Cleanct_Courpus <- tm_map(ct_Courpus, removeWords, stopwords('english'))
inspect(Cleanct_Courpus[1:5])
```

#Remove URL
```{r}
removeURL <- function(x) gsub('http[[:alnum:]]*','', x)
Cleanct_Courpus <- tm_map(Cleanct_Courpus, content_transformer(removeURL))
Cleanct_Courpus <- tm_map(Cleanct_Courpus, stripWhitespace)
#Cleanct_Courpus <- tm_map(Cleanct_Courpus, removeWords, c("cant","can't"))
#Cleanct_Courpus <- tm_map(Cleanct_Courpus, gsub,
#pattern = 'covid"',
#replacement = 'covid')
inspect(Cleanct_Courpus[1:5])
```


```{r}
ct_DFM <- dfm(ct$text,
              remove_punct = TRUE,
              remove = stopwords("english"))
```

TOP Features
```{r}
topfeatures(ct_DFM)
```

```{r}
textstat_frequency(ct_DFM)
```




Term Document Matrix
```{r}
ct_TDM <- TermDocumentMatrix(Cleanct_Courpus)
inspect(ct_TDM)
```
View the data as Matrix
```{r}
ct_TDM <- as.matrix(ct_TDM)
ct_TDM[1:10,1:20]
```


# Bar Plot
```{r}
W <- rowSums(ct_TDM)
W <- subset(W, W>=150)
W
barplot(W, las = 2,
        col = rainbow(50))
```

```{r}
library(wordcloud)
W <- sort(rowSums(ct_TDM), decreasing = TRUE)
set.seed(222)
wordcloud(words = names(W),
          freq = W,
          max.words = 150,
          random.order = F,
          min.freq = 5,
          colors = brewer.pal(8, 'Dark2'),
          scale = c(5, 0.3),
          rot.per = 0.7)
```

```{r}
#install.packages("wordcloud2")
library(wordcloud2)
W <- data.frame(names(W), W)
colnames(W) <- c('word', 'freq')
head(W)
wordcloud2(W, size = 0.6,
           shape = 'rombo',
           rotateRatio = 0.5,
           minSize = 1)
```



#Sentiment Analysis
```{r}
library(syuzhet)
library(scales)
library(reshape2)
library(dplyr)
library(lubridate)
library(ggplot2)
library(dplyr)
```




TOP Features
```{r}
topfeatures(ct_DFM)
```

```{r}
textstat_frequency(ct_DFM)
```
###############################################################################################
```{r}
ct_word <- as.tibble(ct_DFM)
ct_word
```

```{r}
ct_word %>%
  ggplot(aes(covid)) +
  geom_bar() +
  labs(x = "Count",
       y = "covid",
       title = "Twitter covid ")
```

```{r}
ct_word %>%
  ggplot(aes(tested)) +
  geom_bar() +
  labs(x = "Count",
       y = "tested",
       title = "Twitter Tested ")
```

```{r}
ct_word %>%
  ggplot(aes(positive)) +
  geom_bar() +
  labs(x = "Count",
       y = "tested",
       title = "Twitter Positive Tested ")
```




```{r}
barplot(colSums(ct_word),
        las = 2,
        col = rainbow(10),
        ylab = 'Count',
        main = 'Sentiments Analisis')
```


# Clusters 

```{r}
library(arules)
```

```{r}
ct[, sapply(ct, is.character)]<-lapply(ct[, sapply(ct, is.character)], as.factor)
```


```{r}
ct
```


```{r}
Stweets <- select(ct, "followers_count","friends_count","listed_count", "statuses_count", "favourites_count")
Stweets
```

## Within Sum of squares (wss)
```{r}
# For each k, perform WSS, store the value
wssO <- numeric(5)
for (k in 1:5)
  wssO[k] = sum(kmeans(Stweets, k, nstart = 25) $withinss)
```

```{r}
# Make a data frame out of the WSS results
wssResultsO <- data.frame (k = c(1:5), wss = wssO)
wssResultsO
```


## Visualize WSS
```{r}
ggplot(wssResultsO, aes(x = k, y = wssO)) +
  geom_point() +
  geom_line() +
  labs(title = "K-mean: Tweets", 
       x = "Number of Clusters k",
       y = "Within sum of squares")
```

```{r}
# Set the random seed
set.seed(20)

#Extract only petal lenght and width data for clustering 

Stweets1 <-  data.frame (followers = Stweets$followers_count, favourites = Stweets$favourites_count)
head(Stweets1)
```


```{r}
# Perform kmeans with k set to 3
StweetsCluster <-  kmeans(Stweets1, 2, nstart = 25)
StweetsCluster
```

## Visualization 
```{r}
# Add the cluster assigment to each point 
Stweets$Cluster <- as.factor(StweetsCluster$cluster)

# Get centroids 

centroidstweets <-  as.data.frame(StweetsCluster$centers)
centroidstweets$Cluster <-  as.factor(c(1:2))

#Visualize cluster assigments 
ggplot(Stweets, aes(followers_count, favourites_count, color = Cluster)) +
  geom_point()+
  geom_point(centroidstweets, mapping = aes(x = followers, 
                                            y = favourites, fill = Cluster), 
             size = 5, shape = 13) +
  labs(title = "Tweets", 
       x = "Followers", 
       y = "Favourites")

```
```{r}
# Set the random seed
set.seed(20)

#Extract only petal lenght and width data for clustering 

Stweets2 <-  data.frame (followers = Stweets$followers_count, friends = Stweets$friends_count)
head(Stweets2)
```

```{r}
# Perform kmeans with k set to 3
Stweets_friends_Cluster <-  kmeans(Stweets2, 2, nstart = 25)
Stweets_friends_Cluster
```

## Visualization 
```{r}
# Add the cluster assigment to each point 
Stweets_friends_Cluster$Cluster <- as.factor(Stweets_friends_Cluster$cluster)

# Get centroids 

centroid_friends_stweets <-  as.data.frame(Stweets_friends_Cluster$centers)
centroid_friends_stweets$Cluster <-  as.factor(c(1:2))

#Visualize cluster assigments 
ggplot(Stweets, aes(followers_count, friends_count, color = Cluster)) +
  geom_point()+
  geom_point(centroid_friends_stweets, mapping = aes(x = followers, 
                                                     y = friends, fill = Cluster), 
             size = 5, shape = 13) +
  labs(title = "Tweets", 
       x = "Followers", 
       y = "Friends")

```



```{r}
library(tm)
```

```{r}
head(ct)
```

#Build Corpus
```{r}
ct_Courpus
```
#create term document matrix
```{r}
ct_TDM <- TermDocumentMatrix(Cleanct_Courpus)

t <- removeSparseTerms(ct_TDM, sparse= 0.98)
m <- as.matrix(t)
```

#Plot Frequent term

```{r}
freq <- rowSums(m)
freq <- subset(freq, freq>=50)
barplot(freq, las=2, col= rainbow(25))
```

#Hierarchical word/tweer clustering using dendrogram

```{r}
distancetweet <- dist(scale(m))
print(distancetweet, digit = 2)
hc <- hclust(distancetweet, method = "ward.D")
plot(hc)
rect.hclust(hc, k=25)
```

#NonHerarchical K-means Clustering of Words/ Tweets
```{r}
m1 <- t(m)
set.seed(222)
k <- 20
kc <- kmeans(m1, k)
kc
```


```{r}
head(ct)
```

```{r}
lgtweets <- select(ct, "source","display_text_width", "followers_count","friends_count",
                   "listed_count", "statuses_count", "favourites_count")
lgtweets
```

```{r}
str(lgtweets)
```


```{r}
pairs(lgtweets)
```
```{r}
lgtweets
```

```{r}
unique(lgtweets$source)
```

```{r}
ct[, sapply(ct, is.character)]<-lapply(ct[, sapply(ct, is.character)], as.factor)
```

```{r}
ct[, sapply(ct, is.factor)]<-lapply(ct[, sapply(ct, is.factor)], as.character)
```

```{r}
as.character(ct,source)
```


Tweeter form Web app
Tweeter from Mobile devices
```{r}
lgtweets[lgtweets$source == "Twitter for iPhone", c("source")] <- "Mobile"
lgtweets[lgtweets$source == "Twitter for Android", c("source")] <- "Mobile"
lgtweets[lgtweets$source == "Twitter for iPad", c("source")] <- "Mobile"
lgtweets[lgtweets$source == "TweetCaster for Android", c("source")] <- "Mobile"
lgtweets[lgtweets$source == "TweetCaster for iOS", c("source")] <- "Mobile"
lgtweets[lgtweets$source == "Nighthawk for iOS", c("source")] <- "Mobile"

lgtweets[lgtweets$source == "Twitter Web App", c("source")] <- "WEB_APP"
lgtweets[lgtweets$source == "Twitterrific for iOS", c("source")] <- "WEB_APP"
lgtweets[lgtweets$source == "Tweetbot for i??S", c("source")] <- "WEB_APP"
lgtweets[lgtweets$source == "Twitterrific for Mac", c("source")] <- "WEB_APP"
lgtweets[lgtweets$source == "Twitter for Mac", c("source")] <- "WEB_APP"
lgtweets[lgtweets$source == "Tweetbot for Mac", c("source")] <- "WEB_APP"

lgtweets[lgtweets$source == "Sprinklr", c("source")] <- "Other"
lgtweets[lgtweets$source == "Meme Machine", c("source")] <- "Other"
lgtweets[lgtweets$source == "Sprout Social", c("source")] <- "Other"
lgtweets[lgtweets$source == "StreamElements", c("source")] <- "Other"
lgtweets[lgtweets$source == "Instagram", c("source")] <- "Other"
lgtweets[lgtweets$source == "SocialFlow", c("source")] <- "Other"
lgtweets[lgtweets$source == "Headliner Video", c("source")] <- "Other"
lgtweets[lgtweets$source == "Tumblr", c("source")] <- "Other"
lgtweets[lgtweets$source == "TweetDeck", c("source")] <- "Other"
lgtweets[lgtweets$source == "dlvr.it", c("source")] <- "Other"
lgtweets[lgtweets$source == "Hootsuite Inc.", c("source")] <- "Other"
lgtweets[lgtweets$source == "Echobox", c("source")] <- "Other"
lgtweets[lgtweets$source == "Echofon", c("source")] <- "Other"
lgtweets[lgtweets$source == "AdvisorStream v2", c("source")] <- "Other"
lgtweets[lgtweets$source == "IFTTT", c("source")] <- "Other"
lgtweets[lgtweets$source == "HubSpot", c("source")] <- "Other"
lgtweets[lgtweets$source == "Buffer", c("source")] <- "Other"
lgtweets[lgtweets$source == "ThreadReaderApp", c("source")] <- "Other"
lgtweets[lgtweets$source == "Nora_ebooks", c("source")] <- "Other"
lgtweets[lgtweets$source == "Streamlabs Twitter", c("source")] <- "Other"
lgtweets[lgtweets$source == "LinkedIn", c("source")] <- "Other"
lgtweets[lgtweets$source == "Fenix 2", c("source")] <- "Other"
lgtweets[lgtweets$source == "Twitlonger", c("source")] <- "Other"
lgtweets[lgtweets$source == "Revive Social App", c("source")] <- "Other"
```


```{r}
lgtweets$source<- factor(lgtweets$source, levels = c("Mobile", "WEB_APP"))
```

```{r}
contrasts(lgtweets$source)
```

```{r}
library(caTools)
library(caret)
library(rpart)
library(rpart.plot)
library(party)
```


```{r}
set.seed(123)
lgtweets$Sample <- sample.split(lgtweets$source, SplitRatio = .75)
train_lgtweets <- filter(lgtweets, Sample == TRUE)
test_lgtweets <- filter(lgtweets, Sample == FALSE)
```

#Logistic Model

```{r}
lgModel_tweets <- glm(formula = source ~ ., 
                      data = train_lgtweets,
                      family = binomial)
summary(lgModel_tweets)
```

#Prediction
```{r}
test_lgtweets$lgtweets_Provability <- predict(lgModel_tweets, 
                                              test_lgtweets, type = "response")

#include new predict into dataframe
test_lgtweets <- mutate(test_lgtweets, predictlgtweets = ifelse(lgtweets_Provability < .5, "Mobile", "WEB_APP"))
#convert the leveled factor
test_lgtweets$predictlgtweets <- factor(test_lgtweets$predictlgtweets, 
                                        levels = c("Mobile", "WEB_APP"))
```

#Accuray
```{r}
#Generate Confusion Matrix
confusionMatrix(test_lgtweets$source, test_lgtweets$predictlgtweets)
#Calculate Precision
precsionTweets <- precision(test_lgtweets$source, test_lgtweets$predictlgtweets)
#Calculate Recall
recallTweets <- recall(test_lgtweets$source, test_lgtweets$predictlgtweets)
#To Print the output
cat("Precision is:", precsionTweets, "\n")
cat("Recall is:", recallTweets, "\n")
```

```{r}
head(lgtweets)
```

```{r}
set.seed(123)
ct$Sample <- sample.split(ct$source, SplitRatio = .75)
train_ct <- filter(ct, Sample == TRUE)
test_ct <- filter(ct, Sample == FALSE)
```

#Decision Tree
```{r}
ctreelgTweets <- ctree(source ~ display_text_width + followers_count +
                         friends_count + listed_count + statuses_count +
                         favourites_count, data = ct)
plot(ctreelgTweets)
```

#Predic Ctree
```{r}
# Predict Ctree 
prediction_cTree_ct <- predict( ctreelgTweets, newdata = test_ct)
# Tree Results
result_cTree_ct <- table(test_ct$source, prediction_cTree_ct, dnn = c("Actual", "Prediction"))

# Tree Accuracy
accuracy_cTree_ct <- sum(diag(result_cTree_ct)) / sum(result_cTree_ct)
#to print Output
cat("The accuracy of the model is", accuracy_cTree_ct)
```
ctreelgTweets <- ctree(source ~ display_text_width + followers_count +
                         friends_count + listed_count + statuses_count +
                         favourites_count, data = ct)
plot(ctreelgTweets)
#Decision tree CART
```{r}
cartTree_Tweets <- rpart(source ~ display_text_width + followers_count +
                           friends_count + listed_count + statuses_count +
                           favourites_count, data = ct)


#Plot Rpart
rpart.plotTweets(cartTree_Tweets, extra = 2, under = TRUE)

#Predict CART
cartTree_Tweets <- predict(cartTree_Tweets, newdata = test_ct)
#Cart Results
result_CART_Xdata <- table(test_Xdata3$VarX, cartTree_NewData, dnn = c("Actual", "Prediction"))
#CART Accuracy
accuracyCART_Xdata <- sum(diag(result_CART_Xdata))/ sum(result_CART_Xdata)
#to print Output
cat("Accuracy of the model CART is:", accuracyCART_Xdata)
```



# For save the dataset as CSV
```{r}
tibble_with_lists_to_csv <- function(tibble_object, file_path_name) {
  set_lists_to_chars <- function(x) { 
    if(class(x) == 'list') { y <- paste(unlist(x[1]), sep='', collapse=', ') } else { y <- x  } 
    return(y) }
  new_frame <- data.frame(lapply(tibble_object, set_lists_to_chars), stringsAsFactors = F)
  write.csv(new_frame, file=file_path_name)
}

# change to new data set name 
tibble_with_lists_to_csv(ct, "ctsave.csv")
```