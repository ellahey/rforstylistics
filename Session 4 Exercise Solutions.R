# --------------------------------------------------
## Session 4: Exercise Solutions
# --------------------------------------------------


# Exercise 4.1 -------------------------------------
# Have a look at the geom_text() function and find out how you can adjust
# the positioning of the geom_text. Play around with it until 
# you have found a position you like. 

# Read the documentation:

?geom_text()

# The information we're looking for is under the header "Alignment".
# We can use vjust (vertical) and hjust (horizontal) aesthetics to move the text around. 
# We'll most likely want to adjust them horizontally, to move the label either inside the bar
# or outside it. We can use characters or numbers to do this. 
# hjust = "right" will move them inside the bars, hjust = "left" outside the bars.
# I will go with hjust = 1.2

top_ten %>%
  ggplot(aes(x = n, y = word)) + 
  geom_col() + 
  geom_text(aes(label = n), hjust = 1.2) + # mapping data to visual with aes()
  labs(title = "10 Most Frequent Words in Jane Austen's Novels (excluding stopwords)",
       y = "Words", x = "Raw Frequency")


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

# Unnesting austen tokens from the column 'text', into the new column 'word'
austen_all_tidy <- austen %>%
  unnest_tokens(word, text)

# Creating a new tibble for words and their frequencies
raw_freq_all <- count(austen_all_tidy, word)

# Sorting the frequency df in descending order, taking the first 20 and assigning them to top_20_all
top_20_all <- raw_freq_all %>%
  arrange(desc(n)) %>%
  slice_head(n = 20)

# Now on to the plot
top_20_plot <-  top_20_all %>% # creating a plot object, piping top_20_all into ggplot() function
  ggplot(aes(x = reorder(word, n), y = n)) + # mapping words to x axis ordered by frequency and frequency to y axis
  geom_col(fill = "orange") + # specifying bar color
  labs(title = "20 Most Frequent Words in Jane Austen's Novels", # specifying a title
       subtitle = "Including Completed Works Only", # specifying a subtitle
       x = NULL, y = "Frequency") + # setting x axis label to 'NULL' to override default of printing col name
  theme(plot.title = element_text(size = 14, face = "bold"), # making title bold and 14pt size
        plot.subtitle = element_text(size = 12, face = "italic")) # italicizing subtitle and setting 12pt size

ggsave(filename = "top_20_jane_austen_words.pdf")

