#### Session 7: KWIC (and POS tagging) ####

library(tidytext)
library(quanteda)
library(udpipe)

# For this session we'll return to the White Fang dataframe that we created in 
# Session 5. We wrote this to disk - getting it into our current session 
# environment requires us to read it back in:

wf <- read_csv("Data/wf.csv")

#### 7.1 KWIC ####

# We're going to see how we can use R to generate a KWIC concordance - a list of 
# all instances of a search term, including a preview of its immediate (co-textual) 
# context.

# We'll use the package **quanteda** for this session. **quanteda** is designed
# for corpus analysis and has many useful functions. A tutorial can be found
# here: https://tutorials.quanteda.io/

# Creating a KWIC concordance object using **quanteda** is fairly straightforward,
# since **quanteda** has a built-in `kwic` function. However, before we begin, we
# need to know what keyword we're interested in. Complete TASK 1 below before we 
# go further:

# ________________________________________________
#### TASK 1: ####

# Let's say we want to see a KWIC concordance for one of the most frequent words in
# White Fang. Using what you learned in Session 5, write some code to find out what 
# the ten most frequent words are.
#__________________________________________________

# In order to use most **quanteda** functions, our data first needs to be transformed
# into a 'corpus' or 'tokens' object. I won't get into the nature of these object types
# here. You can read more about these data types on the tutorial website linked
# above.

# We'll start by transforming the White Fang text we just tidied in TASK 1 into 
# a tokens object:

wf_tokens <- tokens(wf$text)

# Now it's just a matter of choosing a keyword to investigate and applying the 
# `kwic` function. Let's start with the third most frequent word (after 'white'
# and 'fang'): "one"

kwic(wf_tokens, pattern = "one") 

# You'll see that the right-hand context appears below our keyword, which is not 
# ideal. We can fix this by specifying the width of the output window, using the
# `print` and `object` functions. The default width is 80.


kwic(wf_tokens, pattern = "one") %>%
  print(options(width=120))

# We can save this kwic concordance as an object:

kwic_one <- kwic(wf_tokens, pattern = "one") 

# You can also increase or decrease the context window for the kwic, using the
# 'window' argument:

kwic(wf_tokens, pattern = "one", window = 6) %>%
  print(width = 120)

kwic(wf_tokens, pattern = "one", window = 3) %>%
  print(width = 120)


# ______________________________________________
#### TASK 2 ####

# Create a kwic concordance for another word in the 10 most frequently-occurring
# words in the novel.

#_________________________________________________

#### 7.2 POS tagging ####

# For POS tagging we need the **udpipe** package. 

# The first step is to load a language model for English. **udpipe** has 4 
# models for English (as well as models for 63 other languages). You can read more
# about **udpipe** and follow links to info on these models here: 
# https://cran.r-project.org/web/packages/udpipe/vignettes/udpipe-annotation.html#udpipe-models

# We'll work with the "english-gum" model, which is based on a corpus of texts from
# several different registers.

model   <- udpipe::udpipe_download_model(language = "english-gum")

# Now we load the model:

model <- udpipe_load_model(model)

# POS tagging can take a lot of time, depending on your machine - it's the kind of
# operation you might want to set up to run overnight. So we won't try to 
# annotate the entire novel in this workshop. Instead, we'll just annotate the first
# 3 chapters.

# We start by subsetting the first 3 chapters and saving these as a new dataframe:

chs1_3 <- wf[1:3,] # remember that when subsetting, the order is [row, column]. 
# The colon says we want rows 1 through 3.

# Now we tag the text using the `udpipe_annotate` function. The required arguments
# here are the model we want to use (which we've saved as 'model'), and the
# object we want to annotate. In our case we want to annotate the second column (the
# text column) of our chs1_3 dataframe. We can specify this using $ subsetting:

chs1_3 <- udpipe_annotate(model, pos_test$text) %>%
  as_tibble() 

# You may wonder why I've added the `as_tibble` function. `udpipe_annotate` results
# in a large data object. By adding the `as_tibble` function, we transform this into 
# a more efficient (data-usage wise) object (because tibbles are computationally 
# lighter).

# Let's inspect our resulting tibble:

head(chs1_3)

names(chs1_3)

# We see a lot of variables here - to keep things simple, we'll just work with
# three of these: the 'doc_id', 'token' and 'upos' (universal parts of speech)
# variables. You can read about the other variables here if you like: 
# https://universaldependencies.org/format.html):

selection <- chs1_3[, c(1,6,8)]
selection


#### 7.3 Working with the data ####

# Now we can work with this data. For instance, let's say we want to see the most
# frequently-occurring nouns. We can isolate the nouns by filtering out only those
# 'upos' values that equal "NOUN":

nouns <- selection %>%
  filter(upos == "NOUN")

head(nouns)


# Our 'nouns' dataframe contains 1915 nouns. But some of these will obviously be
# repeated. Let's see how many unique nouns we have. 

unique(nouns$token)

# Now let's find out what the most frequent nouns are and create a new dataframe
# called 'freq_nouns' that arranges these in order from most to least frequent.

# ________________________________________________
#### TASK 3: ####
# How would we do this? 

# ________________________________________________

# Let's inspect our frequent nouns:

head(freq_nouns)
tail(freq_nouns)

# We can see that some words have likely been mistagged ("yell"). However, the tested
# accuracy of the udpipe tagger is nearly 94% - see: 
# https://github.com/jwijffels/udpipe.models.ud.2.5/blob/master/inst/udpipe-ud-2.5-191206/README


#### 7.4 Visualization ####

# Let's create a visualization that summarizes our noun frequencies. We'll use 
# `geom_col` to create a bar chart with our noun tokens on the y-axis and the 
# counts (n) on the x-axis:


freq_nouns %>%
  ggplot() +
  geom_col(aes(n, token))

# This is rather busy, because it has plotted *all* the nouns. Let's make this a bit
# more focused. We'll select just the top 20 most frequent nouns:

freq_nouns[1:20,] %>%
  ggplot() +
  geom_col(aes(n, token))

# You'll see that ggplot has rearranged our data so that it is now ordered
# alphabetically by token. We want the bars to be ordered in terms of their length
# (i.e. by frequency). We can adjust this using the `reorder` function:

freq_nouns[1:20,] %>%
  ggplot(aes(x = n, y = reorder(token, n))) + 
  geom_col ()

# Much better! Let's save this as an object, so we can continue to add layers
# to it later without repeating the entire code block.

viz <- freq_nouns[1:20,] %>%
  ggplot(aes(x = n, y = reorder(token, n))) + 
  geom_col ()

#### 7.5 Making it pretty ####

# _________________________________________
#### TASK 4: ####

# Improve the appearance of your visualization by adding: a title, an x-axis label,
# and a y-axis label.

# ________________________________________


# We can adjust the colour of the bars by adjusting the ggplot aesthetics:

freq_nouns[1:20,] %>%
  ggplot(aes(x = n, y = reorder(token, n))) + 
  geom_col (fill = "blue") +
  labs(title = "Most frequent nouns in White Fang Chs 1-3") +
  xlab("Frequency") +
  ylab("Noun")

# __________________________________________
#### TASK 5: ####
# Play around with changing the colour of the bars. There's a handy R colour
# cheatsheet available here: http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
# __________________________________________

# When you're happy with the appearance, save your visualization as an object
# again:

viz <- freq_nouns[1:20,] %>%
  ggplot(aes(x = n, y = reorder(token, n))) + 
  geom_col (fill = "blue") +
  labs(title = "Most frequent nouns in White Fang Chs 1-3") +
  xlab("Frequency") +
  ylab("Noun")

# You can now export this as an image or pdf.


# _____________________________________________
#### TASK solutions ####

# TASK 1:

library(tidyverse)

wf_tidy <- wf %>%
  unnest_tokens(word, text)

my_stopwords <- get_stopwords(language = "en", source = "snowball")

wf_tidy <- anti_join(wf_tidy, my_stopwords)

wf_tidy %>% 
  count(word) %>%
  arrange(desc(n))

# TASK 2 (e.g.):

kwic(wf_tokens, pattern = "one") %>%
  print(show_summary = quanteda_options(("print_tokens_summary")))

# TASK 3:
# We can use `count` and `arrange`:

freq_nouns <- nouns %>%
  count(token) %>%
  arrange(desc(n))

# TASK 4:

viz <- viz +
  labs(title = "Most frequent nouns in White Fang Chs 1-3") +
  xlab("Frequency") +
  ylab("Noun")


# TASK 5: (e.g.)

freq_nouns[1:20,] %>%
  ggplot(aes(x = n, y = reorder(token, n))) + 
  geom_col (fill = "deepskyblue") +
  labs(title = "Most frequent nouns in White Fang Chs 1-3") +
  xlab("Frequency") +
  ylab("Noun")


#### Exercises ####

# 1. Create a bar chart for the most frequent verbs in chapters 1-3 of White Fang.

# 2. What is the most frequently-occurring upos in chapters 1-3 of White Fang?

# 3. What happens when you add the geom `theme` to your visualization? Try adding
# one of the options below (commented out for now - remove hashtags):

# +
#   theme_bw()
# 
# +
#   theme_classic()
# 
# +
#   theme_dark()




