# --------------------------------------------------
## Session 4: Visualizations with ggplot2
# --------------------------------------------------

# Introduction -----------------------------------------
# In this session we will learn how to create and save good looking plots using ggplot.
# ggplot2 is a very popular package and comes with the tidyverse package that you have already installed. 
# First of all, let's load the library again.

library(tidyverse)


# Before we do anything with this package, let's have a quick look at the documentation.

?ggplot2



# Setting up -------------------------------------------
# The 'gg' in ggplot stands for grammar of graphics. 
# We will be creating visualizations of the jane austen data we have already worked with in Session 3. 
# To make sure we're all on the same page, let's re-run the following code from last session 
# so that we have that data in our environment again:

library(janeaustenr)
library(tidytext)

austen <- austen_books()


(austen_tidy <- austen %>%
    unnest_tokens(word, text))

my_stopwords <- tidytext::get_stopwords(language = "en", source = "snowball")

austen_tidy <- anti_join(austen_tidy, my_stopwords)

(raw_freq <- count(austen_tidy, word))

# First of all, we'll get acquainted with the basics of ggplot2 by creating a 
# bar plot of the 10 most frequent words (excluding stopwords!) across all the Jane Austen novels. 
# To make things clearer while we learn the ggplot2 syntax, let's create a data frame
# that only contains the 10 most frequent words. 
# We can do that by arranging the raw_freq tibble from earlier in descending order (as we have done in Session 3)
# and then 'slicing' the first 10 rows off of it. 
# slice(), slice_head() and slice_tail() are very handy functions from the dplyr package
# that allow you to select rows using integer locations. There's different ways we can write that.

top_ten <- raw_freq %>% 
  arrange(desc(n)) %>%
  slice(1:10) # slice rows 1 to 10

# Alternatively we could write
top_ten <- raw_freq %>%
  arrange(desc(n)) %>%
  slice_head(n = 10) # slice the first 10 
                     #(head indicates the first however many, the parameter n specifies how many exactly)


# The Basics of ggplot ---------------------------------
# To create a plot, we use the ggplot() function. 
# To create a ggplot, we need 3 essential components:
# 1) *data* in form of data frame
# 2) *aesthetic mappings* aes(): relating data to visual
# 3) *geom layer* geom(): geometrical object, e.g. bar, pie, points

# These are the building blocks of creating ggplot plots in R. 
# Let's run the line of code below and watch the magic happen:

ggplot(top_ten, aes(x = n, y = word)) + geom_col()

# Let's unpack what's going on here:
# The first argument we supply to the ggplot() function is a data frame, in this case, top_ten.
# Still in the ggplot() function, we then specify the aesthetic mappings. 
# These tie our data to the visual properties of the plot. 
# We're saying: take the n column of the top_ten as the x axis and the word column as the y axis. 
# If we run only that, we get the frame of what will be our plot, without
# any bars/lines/scatterplots/etc.
# The type of figure we want R to draw is specified in the geom layer. 
# In this case, we use geom_col() to create a bar graph.


# We could also write this using the pipe operator.

top_ten %>%
  ggplot(aes(x = n, y = word)) + geom_col()


# Plot Title and Axis Labels ---------------------------
# That's a great start. We can improve this plot by adding some more information,
# such as a title and axis labels. 
# We can do all of this by adding a labs() layer. 
# Let's start with a title:

top_ten %>%
  ggplot(aes(x = n, y = word)) + 
  geom_col() + 
  labs(title = "10 Most Frequent Words in Jane Austen's Novels (excluding stopwords)")

# We can specify axis labels in the same way, using x = "" and y = "".
top_ten %>%
  ggplot(aes(x = n, y = word)) + 
  geom_col() + 
  labs(title = "10 Most Frequent Words in Jane Austen's Novels (excluding stopwords)",
       y = "Words", x = "Raw Frequency")

top_ten %>%
  ggplot(aes(x = n, y = word)) + 
  geom_col() + 
  labs(title = "10 Most Frequent Words in Jane Austen's Novels (excluding stopwords)",
       y = "Words", x = "Raw Frequency")


# Adding Data Point Labels -----------------------------
# Looking good. Let's think of other ways we could improve this plot. 
# We could add labels to each bar to indicate the frequency of each word. 
# We can do this by addig a geom_text() layer. 

top_ten %>%
  ggplot(aes(x = n, y = word)) + 
  geom_col() + 
  geom_text(aes(label = n)) + # mapping data to visual with aes()
  labs(title = "10 Most Frequent Words in Jane Austen's Novels (excluding stopwords)",
       y = "Words", x = "Raw Frequency")


# Cool. We got numbers. But the positioning of them is ... sub-optimal.


# Exercise 4.1 -----------------------------------------
# Have a look at the geom_text() function and find out how you can adjust
# the positioning of the geom text. Play around with it until 
# you have found a position you like. 




# Finally, let's add some color. There's different ways of doing this. The first way is to
# specify a fill argument in the aes() function. 
# looking  up which colors they can put

top_ten %>%
  ggplot(aes(x = n, y = word)) + 
  geom_col(fill = "steelblue") + 
  geom_text(aes(label = n), hjust = 1.2) + 
  labs(title = "10 Most Frequent Words in Jane Austen's Novels (excluding stopwords)",
       y = "Words", x = "Raw Frequency")

# I'd say this is pretty good. One last thing I'd want to change is the order of the bars,
# so that they are ordered by frequency. We can do this using reorder() in the aes mapping.

top_ten %>%
  ggplot(aes(x = n, y = reorder(word, n))) + #reorder word by n 
  geom_col(fill = "steelblue") + 
  geom_text(aes(label = n), hjust = 1.2) + 
  labs(title = "10 Most Frequent Words in Jane Austen's Novels (excluding stopwords)",
       y = "Words", x = "Raw Frequency")


# Saving our plot --------------------------------------
# Once you're happy with your plot, you can save it onto your machine
# using the ggsave() function. If you don't specify a particular plot, 
# it will automatically save the last plot you displayed. 
# You can choose the type of file you want to create, e.g. .png, .jpg, .pdf

ggsave(filename = "my_first_plot.png")


# We can check whether it worked with list.files(), which will print out
# the files that are currently living in your working directory. 

list.files()


# This should now have been saved in your working directory. 


# Exercise 4.2 -----------------------------------------
# For a stylistic analysis, we might often be quite interested in the kinds of words that we have previously removed.
# For this exercise, plot the 20 most frequent words, including stop words.

# This may seem like a big task. One of the most important things about coding is to clearly plan out
# which steps you need to perform to generate the output you want. Below you find some guidance on how to tackle this.

# First you will need a data frame containing the 20 most frequent words. You can use the steps from Session 3 to 
# guide you (just remember to skip the step where we removed the stopwords.)
# Once you have a data frame with the 20 most frequent words, you can move on to plotting them.
# Start by creating a basic plot. Then start playing around with the design of it. 
# You could swap around the variables, to have vertical bars, you could skip the labels, change 
# the color, etc. We have only scratched the surface of the options available when customizing ggplots.
# For example, you could change the background color of the plot, the fill color of the bars,
# the font of the labels etc. 
# You can have a look at this page for some inspiration and code snippets:
# https://ggplot2.tidyverse.org/articles/faq-customising.html
# When you are happy with your plot, save it in a format of your choice. 



# Time Permitting --------------------------------------
# From a stylistic point of view, one question we might be interested in is how word frequencies
# vary across different works by the same author.  
