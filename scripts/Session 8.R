# --------------------------------------------------
## Session 8: Saving to Disk
# --------------------------------------------------

# We will need stringr later on, so let's load the library.
library(stringr)


# Reading in .csv file -----------------------------
# In Ernestine's session on webscraping we already wrote our data frame of scraped text
# to a csv file. csv files are a very useful format for loading data back into R.
# If you wanted to use the data you scraped with a different software for further analysis however,
# such as AntConc, WMatrix or SketchEngine to name a few software programs for corpus analysis, 
# then you might need your data in the form of .txt files.
# In this session we will write each chapter of White Fang to it's own text file. 

?read.csv

# First of all, let's read in our cv file again and assign it to a dataframe object 'wf'
# If you have saved it the same way as Ernestine suggested in Session 5, the line below should work for you
wf <- read.csv("Data/wf.csv")

# I have my files organised differently, so I'll run this:
wf <- read.csv("/Users/sarabartl/Desktop/RWorkshop/wf.csv")



# Taking a Look ------------------------------------
# Let's have a look at the data frame it to remind ourselves of what it looks like. 
head(wf)
summary(wf)


# Some More Cleaning -------------------------------
# Looks all good. It has loaded properly, and we have our 25 chapters with pretty clean text.
# The only thing we might want to change before writing the chapters to .txt files is the '\n' sequences that 
# we still have in the text. \n is a way of making a new line, so that is probably where they come  from.
# In a corpus software however, it will interfere with your frequency counts etc.
# We already did some cleaning in Session 5 using regular expressions. We can use the same functions again here:

wf$text <- str_remove_all(wf$text, "\n")

head(wf)


# Writing to .txt files ----------------------------
# Looking even better. Now we're ready to write our text to .txt files. Our goal is to have 
# each White Fang chapter as a separate .txt file. 

# Our goal is to have each chapter of White Fang as a separate .txt file. 
# Let's first see how this would work for a single chapter.

chapter1 <- wf[1, "text"] # create an object containing the text of chapter 1
write.table(chapter1, "wfchapter1.txt") # use the write.table() function to write a .txt file

# We know that White Fang has 25 chapters:
summary(wf)

# If we want to create a .txt file for each chapter, we would need to write the above two lines of code 25 times
# (or copy paste them and slightly adjust 25 times)
# 25 may be a small enough number for that to still be somewhat feasible, 
# but why go to all that trouble when you can achieve the same thing with a for loop in 4 lines?

for (i in 1:nrow(wf)) {
  chapter <- wf[i, "text"] # create a chapter variable for the chapter in the nth row of wf
  file_name <- paste0("WFchapter", i, ".txt") # create a file name variable following a general pattern of chapter, n, extension
  write.table(chapter, file_name) # again, call the write.table() function and pass it the chapter text and file name
}


# We might also want to have one .txt file that contains all of White Fang.
# Here's a loop that allows us to do that

full_book = c() # initialize an empty object that will eventually contain all chapters
for (i in 1:nrow(wf)) { # loop through all the rows of wf
  current_chapter <- wf[i, "text"] # assign the content of the text column of the nth row to the object current_chapter
  full_book = c(full_book, current_chapter) # add the 'current' current_chapter to full_book
}

# After the loop has finished, and all the rows/chapters have been added to full_book
# we can again use the write.table() function to write our text to a .txt file
write.table(full_book, "WhiteFang.txt")


# Exercise 8.1 -------------------------------------
# For the last exercise of this workshop, write the Guardian article
# about Charles Dickens you scraped for the exercise in Session 5 to your
# disk as a .txt file. Imagine you wanted to use it for further analysis
# outside of R, so make sure to clean it if necessary. 

