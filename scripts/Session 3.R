#### Session 3: Working with text data (I): tidytext and frequency analysis ####

# In this session we will learn to work with the **tidytext** package, which we will use
# to perform some basic frequency analysis. The data we will use is a corpus of 
# Jane Austen's novels which is available as the R package **janeaustenr**.

#### 3.1 Getting started ####
# Begin by opening a new script (File > New File > R Script). Give it a suitable name 
# ("Session 3" e.g.), and save it in the "Scripts" folder of your working directory.
# At the top of your script, load the necessary packages using the code chunk below.

# Note: Due to problems loading packages after updating R, I had to first run the code below 
# to get the packages to install and load. You may or may not have to do the same.
# install.packages("Rcpp", type="binary")
# install.packages("SnowballC", type = "binary")

library(tidyverse)
library(janeaustenr)
library(tidytext)


# Let's have a look at the texts included in the **janeaustenr** package. **TIP**:
# whenever you want to see the various functions contained within a specific package, 
# type the name of the package followed by two colons; R will bring up a menu that 
# shows you all the package functions. 

# Try it: type `janeaustenr::` into your script and hit Ctrl+Enter.
# 
# We want to work with the `austenbooks()` function, which is a dataset comprising 
# all of Austen's novels. We'll begin by saving the dataset in our R session 
# environment by assigning a new name to it (this is good practice whenever you 
# plan to make changes to a built-in dataset; you can always return to the original 
# by calling the package function later). Let's call the dataset 'austen'.

austen <- austen_books()

# The empty parenthesis here indicate that we are calling the function, but we 
# are not specifying any additional arguments for that function (if we were,
# we would put those arguments inside the parentheses, as we've seen before in Session 2).

#### 3.2 Inspecting the dataset ####

# Let's inspect the dataset. 

# There are several ways to inspect a dataset. The most useful methods are `glimpse`:

glimpse(austen)

# and `head`, `tail`

head(austen)
tail(austen)


# We can see that the dataset consists of two variables - 'text' and 'book', and 
# that each row of the dataset corresponds to a line of text.

# Looking at the head and tail of the dataset, we immediately notice that there 
# are many rows in the 'text' column which are empty. Later, we will walk through 
# how to clean up the dataset by removing these empty rows (time allowing). 


#### 3.3 Analysis with tidytext ####


# **tidytext** is a package designed for working with text data. The first step 
# to doing analysis with tidytext is to use a function called `unnest_tokens`. 
# This function returns a dataframe in which each row corresponds to a single 
# token (word). Again, it's good practice to save this new dataframe using a 
# new name, in case we want to return to the previous version of the data later. 
# I'll call mine 'austen_tidy'.

(austen_tidy <- austen %>%
    unnest_tokens(word, text))

# ___________________________________________

#### Code explainer: %>% (pipe) operator ####

l <- c(1, 23, 89.2, 9, 4.3, 12)

mean(l)

round(mean(l))

sqrt(round(mean(l)))

l %>%
  mean() %>%
  round() %>%
  sqrt()

# ____________________________________________


# You'll notice that there are common grammatical words in our new dataframe which 
# we may wish to eliminate for the purposes of frequency analysis. Luckily, 
# **tidytext** provides an easy way of doing this. **tidytext** includes 3 stopword 
# lexicons for English. Here I'll use the 'snowball' lexicon.


# We can have a look at the snowball lexicon by calling the `get_stopwords` function 
# and specifying language as English and source as 'snowball'.

get_stopwords(language = "en", source = "snowball")

# Let's save the stopwords as an object in our R session environment. We can call
# the new object 'my_stopwords'

# ____________________________________________

#### TASK 1: ####
# How would we do this? 

# ____________________________________________


# To remove stopwords from the dataframe, we need to work with the **dplyr** 
# function `anti_join` `anti_join` works by comparing two matching columns 
# (i.e. columns with the same variable names) and removing any rows from the target 
# dataframe (in this case 'austen_tidy') that match the reference dataframe 
# (the stopwords dataframe).

austen_tidy <- anti_join(austen_tidy, my_stopwords)


#### 3.3.1 Frequency analysis ####

# We're now ready to do some frequency analysis. We'll use the **dplyr** 
# `count()` function to generate a raw frequency count of all the words in the 
# 'word' column of the austen_tidy dataframe.

(raw_freq <- count(austen_tidy, word))

# We immediately see some issues that we would want to address via a more thorough 
# cleaning of the data - some words are surrounded by underscores! We won't do this 
# for now, but we'll include instructions for how to do this at the end of this 
# session. For now, let's have a closer look at this frequency data. We can see 
#the range of frequencies, from lowest to highest, using the function `range`:

range(raw_freq$n)

# If we just wanted to know the frequency of the most frequent word, we could 
# use `max`:
  
max(raw_freq$n)

# ___________________________________________

#### TASK 2: ####
# How do you think we could find the frequency of the least frequent word?

# ___________________________________________

# The most frequent word in the corpus is one that occurs 3015 times. Of course, 
# there could be multiple tokens that occur 3015 times. We can check if this is 
# the case using the function `which`. 

which(raw_freq$n == 3015)
  
# The code above says "give me the indexes (i.e. the locations) 
# of the occurrences of the value 3015 in the 'n'column of 'raw_freq' dataframe.
# It returns only one result (i.e. one location, one row number), which means
# that the value 3015 occurs only one time in the 'n'column and is therefore
# a unique frequency.

# Let's find out which word this most freuqent word is. We need to find where it is located in the 
# dataframe. We can do this by using the function `which()`and combining this with 
# our previous `max` function:

which(raw_freq$n == max(raw_freq$n))

# Remember that we use == instead of = because == is a Boolean operator
# for checking the equivalence of two values. = is another way of writing <- (it is 
# another way of assigning a variable to an object).

# 8477 is the *index* where the word identified 
# earlier is located. I.e. if we look at row 8477 in column 'n' we will see the
# most frequently-occurring word in the corpus. But it's not efficient to open the 
# dataframe and scroll down to row 8477. Instead, we can use simple square-bracket 
# subsetting to do this. 

# Remember when subsetting using square brackets that the order is [row, column]. 
# Here, the row is 8477, and we need the 'word' column, which is the first column 
# of the raw_freq dataframe. Run the code below to identify the most 
# frequently-occurring word:

raw_freq[8477,1]

# Let's say we want to look at the top 10 most frequent words, in order from most 
# frequent to least frequent. We can do this by using the `arrange()` function. 
# `arrange` does just what it says - it arranges data in a specified order. 
# Here we will choose descending order (most frequent to least frequent).


raw_freq %>%
  arrange(desc(n))

# ________________________________________________
#### TASK 3: ####
# I've used the pipe operator %>% above, but there is another way to write this 
# code. What is it?
# _______________________________________________

# The section that follows is a "time-allowing" section and contains some more 
# advanced code. If we don't get to this as a group, feel free to complete the 
# section below independently.

#### 3.4 Time allowing - Cleaning the data ####
  
# Let's return to our 'austen' dataframe and learn how we could clean this up to 
# remove unwanted values before repeating the frequency analysis above. 

# Often, missing values are indicated by NA. However, in our 'austen' dataset, 
#there are no NA values in the text column. We can confirm this by using the 
# function `anyNA` and applying this to the text column using $ notation:

anyNA(austen$text)

# The missing values in the 'text' column are just empty ("") values. To eliminate 
# these, we can filter out all rows which are *not* empty. The code for this is 
#as follows:

austen_clean <- austen[!(austen$text == ""), ]


# Here, we create a new object, 'austen_clean', with the rows of missing values 
# removed. The square brackets indicate that we are subsetting our original 
# 'austen' dataframe. The ! operator negates any condition that follows it. The 
# condition we are negating here is `== ""`. So basically we are saying: return 
# all rows which do **NOT** contain empty values. The parentheses are necessary 
# for grouping - this is what allows R to know what argument we want our negate 
# operator to apply to. Finally, the comma after the parentheses tells R to do 
# this for all rows. This is a rather complicated chunk of code for a beginner. 
# Don't worry too much if it's not 100% clear. 

# We may have noticed some other values in our dataframe that we might not want 
# to include in our text analysis. For example, "by Jane Austen", as well as 
# chapter headers. We can use the same process as outlined above to eliminate these.


# Remove "by Jane Austen":
austen_clean <- austen_clean[!(austen_clean$text == "by Jane Austen"),]

head(austen_clean)

# Remove chapter headers:
  
austen_clean <- austen_clean[!str_detect(austen_clean$text, "CHAPTER.+"),]

# The full stop and plus sign after CHAPTER in the code above are regular 
# expression notation that means "find any character one or more times". 
# This will capture anything that comes after 'CHAPTER'.

# A regular expression is a sequence of characters that allows you to find patterns 
# in a text string. Regular expressions are a language in themselves, and we won't 
# have time to teach you how to use these in  anything like a thorough way during 
# this workshop. We encourage you to learn more and practice using them. A guide 
# to regular expressions can be found here: https://www.regular-expressions.info/

# To remove dates (like (1811) in line 5 of the current dataframe), we can again 
# use regular expressions to extract all instances of digits within parentheses. 

austen_clean <- austen_clean[!str_detect(austen_clean$text, "(\\d+)"),]

head(austen_clean)

# The code above works as follows:
  
  # | Syntax  | Description |
  # | -----------  | ----------- 
  # | `!`          | negate |
  # | `str_detect` | Literally, "detect the following string".|
  # | `austen$text`| The vector we want to search.|
  # | `"(\\d+)"`   | One or more digits in parentheses.|
  
# Note that because we are searching for any instances of digits within parentheses, 
# if this pattern occurs anywhere in the actual texts, these will also be removed, 
# but let's assume for now that this is not the case. 

# And finally, let's look at how we could get rid of those underscores that we 
# saw surrounding some words in the 'raw_freq' dataframe when we first inspected 
# it. Let's run through the steps we completed in section 3.3 above with our new 
# (clean) dataframe. First we'll `unnest_tokens` to create a new tidy dataframe 
# from our clean data:
  

(austen_cleantidy <- austen_clean %>%
    unnest_tokens(word, text))

# To fix the values surrounded by underscores, we'll use the `mutate` function 
# together with the `str_remove_all` functions. `mutate` is normally used to add 
# new variables/columns to a dataframe, but it can also be combined with **stringr** 
# functions to modify (recode) existing values in a column. This is a more complex 
# chunk of code, so don't worry if it takes you some time to follow how it works. 


austen_cleantidy <- austen_cleantidy %>%
  mutate(word = 
           str_remove_all(word,"_"))

# Let's just check that this has worked:
count(austen_cleantidy, word)

# And finally, after cleaning the data, you would want to remove your stopwords:

austen_cleantidy <- anti_join(austen_cleantidy, my_stopwords)

# Let's look at the frequency data again using our new, clean dataframe. We'll 
# create a new frequency dataframe with the raw frequency counts:
  
(new_freq <- austen_cleantidy %>%
    count(word)) 

# Let's see the most frequent words:

new_freq %>%
  arrange(desc(n))

# Comparing the most frequent words from our new, clean data with the most frequent 
# words from our old raw_freq dataframe, we see that cleaning the data made no 
# difference for these - the same words occur in the top 10 most frequent words. 
# However, the old raw_freq dataframe contained 14,341 tokens in the 'word' column 
# and the new_freq dataframe contains only 13,867, so nearly 500 words have been 
# removed through cleaning. We can see an overview of these by comparing the two 
# dataframes and returning unmatched values in the 'word' column, using `anti_join`. 

(anti_join(raw_freq, new_freq, by = "word")) 

# That's it. We've learned how to wrangle data and perform a (very) basic frequency 
# analysis and how to clean up messy values in a dataframe. 





# ____________________________________________
#### TASK SOLUTIONS: ####

# TASK 1:

my_stopwords <- get_stopwords(language = "en", source = "snowball")

# TASK 2:
min(raw_freq$n)

# TASK 3:
arrange(raw_freq, desc(n))

# ____________________________________________

#### Exercises ####

# 1. Inspecting a dataframe:
# There are a number of other functions that can be used to get details of the
# structure of a dataframe. Using the 'austen' or 'austen_cleantidy' dataframe,
# try out the functions below. 

nrow()
ncol()
names()
summary()
str()

# Now try the function 'unique' as applied to the 'book' variable of the 'austen_
# cleantidy' dataframe - what does this do?

unique(austen_cleantidy$book)

# 2. Filtering:
# Run the code below. What is the result? Why might this be useful?

(x <- filter(austen_cleantidy, book == "Emma"))


