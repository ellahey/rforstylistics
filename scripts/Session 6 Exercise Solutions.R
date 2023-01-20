# ---------------------------------------------
## Solutions Session 6: Sentiment Analysis
# ---------------------------------------------


# Exercise 6.1 ---------------------------------------
# Using some of the functions we covered yesterday,
# get a sense of the emo_ratings dataset.

head(emo_ratings)
tail(emo_ratings)
summary(emo_ratings)



# Exercise 6.2 ---------------------------------
# Try to figure out why the left_join() still isn't working.
# Feel free to work together.

# The problem with our left_join() function call was that
# even though we had run the rename() function on emo_ratings
# we hadn't assigned it to emo_ratings yet. As a result, 
# left_join() still couldn't find a matching column when we 
# passed (the unchanged) emo_ratings to the left_join() funciton.
# All we need to do is assign rename() to emo_ratings

emo_ratings <- rename(emo_ratings, word = Word)


# Exercise 6.3------------------------------------
# Find out (programmatically) which chapters have the highest
# and lowest mean valence score. 
# Hint: the which() function we covered in Session 3 will come
# in handy here.

# In words: which row in the mean column of the chapter_valence tibble
# holds the value that is identical to the max vlaue in the mean column
# of the chapter_valence tibble
which(chapter_valence$mean == max(chapter_valence$mean)) 
# Then access the chapter column in that row:
chapter_valence[22, 1]

# Same here, just with min() instead of max
which(chapter_valence$mean == min(chapter_valence$mean))
chapter_valence[3, 1]


# Exercise 6.4 ----------------------------------
# As a last step, let's plot the valence means of the individual chapters as a 
# bar plot. Consider how to best map the variables to the axes and chose
# fitting labels. Feel free to add some color and a title. 
chapter_valence %>%
  ggplot(aes(x = mean, y = chapter)) +
  geom_col(fill = "orange") +
  labs(x = "Mean Valence Score", y = NULL) 


# Time Permitting: ------------------------------
# Exercise 6.5
# Sentiment Analysis of Jane Austen Novels

# We're going to start by loading and tidying the jane 
# austen novels. 

library(janeaustenr) # load the janeaustenr library

austen <- austen_books()

# Clean chapter and underscores (we probably don't really 
# need to worry about the rest, as it won't be scored 
# in the valence dataset)
austen_clean <- austen[!str_detect(austen$text, "CHAPTER.+"),]
austen_clean <- austen_clean %>%
  mutate(text = 
           str_remove_all(text,"_"))

# Unnest tokens
austen_tidy <- austen_clean %>%
  unnest_tokens(word, text)

# join austen_tidy and emo_ratings and assign to austen_valence
austen_valence <- left_join(austen_tidy, emo_ratings)

# Like earlier, let's remove the NA values
austen_valence <- filter(austen_valence, !is.na(Val))


# Now compute the mean val score per book
books_valence <- austen_valence %>%
  group_by(book) %>%
  summarize(mean_valence = mean(Val))

# plot it
books_valence %>%
  ggplot(aes(x = mean_valence, y = book)) +
  geom_col(fill = "red")
