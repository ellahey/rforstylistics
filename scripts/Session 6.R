# --------------------------------------------------
## Session 6: Sentiment Analysis 
# --------------------------------------------------

# setwd("/Users/sarabartl/Desktop/RWorkshop")

getwd()
read_csv()

# In this session we will run a simple sentiment analysis of 
# the chapters in White Fang. Sentiment analysis is a popular
# type of analysis to get at the 'sentiment' or 'emotional
# valence' of unstructured text. 

# Load our libraries 
library(tidyverse)
library(tidytext)
library(dplyr)


# Sentiment Analysis -------------------------------
# some background info on sentiment analysis


# Read in White Fang text
list.files()
wf <- read_csv("wf.csv")


# Read in emotional valence data
emo_ratings <- read_csv("Scripts/Session scripts/warriner_valence_ratings.csv")

# Exercise 6.1 ---------------------------------------
# Using some of the functions we have learned yesterday,
# get a sense of the emo_ratings dataset. 
# Using some of the functions we covered yesterday,
# inspect the emo_ratings dataset.




# So the ratings are between 1 and 9, with 1 being the 
# lowest (most negative), and 9 being the highest (most positive).

# Now that we have a better idea of the emotional valence
# ratings, we can think about how we can get a rating for every
# word in our wf tibble. 
# The first thing we will want to do is unnest the wf tokens.
# This is because the kind of sentiment analysis we are doing 
# works on the word level. 




# Okay, so the ratings are between 1 and 9, with 1 being
# the most negative and 9 the most positive. 

# Getting the ratings for White Fang --------------
# We wan to to generate a sentiment score for each White Fang
# chapter. To do this, we need to get a rating score for each
# word in White Fang. 

# First, we want to have a chapter column instead of the url column,
# so that we can keep track of the chapters later
wf_tidy <- wf %>%
  mutate(chapter = paste0("Chapter ", c(1:25)), # create a chapter column
         .before = text, # specify where we want the chapter column
         url = NULL,) %>% # delete the url column
  unnest_tokens(word, text) #unnest the tokens, output, input 

wf_tidy

# Nice. Now we can combine our White Fang words with the valence
# ratings so that each word has its emotional valence rating according
# to Warriner. How do we do this?
?left_join()
left_join(wf_tidy, emo_ratings)

# Okay, we need to rename the emo_ratings column
emo_ratings <- rename(emo_ratings, word = Word)

# Let's try again:
left_join(wf_tidy, emo_ratings)

# Exercise 6.2 ---------------------------------
# Try to figure out why the left_join() still isn't working.
# Feel free to work together.


left_join(wf_tidy, emo_ratings)

wf_valence <- left_join(wf_tidy, emo_ratings)

wf_valence

# It worked. The NA values in our Val column have 
# automatically been added for rows where our emo_ratings
# dataframe did not have matching words. This is because
# the rating data does not contain all words of the English
# language, but 'only' 13915 words. For every word that wasn't 
# rated (and therefore isn't in the emo_ratings dataset), our
# join operation has automatically added an 'NA'.

# We will want to get rid of the NA values. We can do that
# using the filter() function from dplyr. The filter() function
# will keep everything from a tibble that meets a certain condition.
# We first pass the function our tibble, and then specify what of 
# it we want to keep: everything that *isn't* NA in the VAL column.

filter(wf_valence, !is.na(Val))

wf_valence <- filter(wf_valence, !is.na(Val))

# That looks like it did what we wanted it to do. 
# Now we can get to what we initially wanted: a mean valence rating
# for each of the 25 chapters.

# We can compute a mean valence score by using the mean() function
# we already talked about yesterday.
?summarize()

wf_valence %>%
  group_by(chapter) %>%
  summarise(mean = mean(Val))

chapter_valence <- wf_valence %>%
  group_by(chapter) %>%
  summarise(mean = mean(Val))

# Exploring our sentiment analysis ---------------

range(chapter_valence$mean) #range of means
mean(chapter_valence$mean) # mean of means


# Exercise 6.3------------------------------------
# Find out (programmatically) which chapters have the highest
# and lowest mean valence score. 
# Hint: the which() function we covered in Session 3 will come
# in handy here.


# Exercise 6.4 ----------------------------------
# As a last step, let's plot the valence means of the individual chapters as a 
# bar plot. 


# Time Permitting: ------------------------------
# Exercise 6.5
# Sentiment Analysis of Jane Austen Novels
# We have learned how we can use a valence rating dataset to
# conduct a sentiment analysis. The main operation we had
# to perform was the join on the word column, where we
# combined our unnested tibble with the valence ratings. 
# 
# For this exercise, try your hand at conducting a sentiment 
# analysis of Jane Austen novels. 
# Your end result should be a tibble like the one we just
# created for White Fang, but instead of a chapters column,
# you should have a novels column and one valence score 
# per novel. 
#
# Feel free to re-use code from Session 3 to load and tidy 
# the Jane Austen data. Then use the steps from this session
# to guide you through merging the Jane Auten tibble with the
# valence ratings. Don't worry if it doesn't work straight away -
# this is a pretty big project already. Just try to do as many
# steps as you can, and if something doesn't work, refer to the
# Session 6 Exercises Solutions script to get you to the next
# step. 







# Additional Exercises ------------------------------------
# 1) Google and have a look at the different kinds of joins 
# available in the dplyr package. They're a bit confusing
# but it is good to know that different ones exist.
# When you need to use them, you can always look them up
# to decide which one you need. 


