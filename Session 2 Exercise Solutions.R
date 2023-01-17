# ---------------------------------------------
## Solutions Session 2: R Basics
# ---------------------------------------------

# Exercise 2.1 --------------------------------

# Jane Austen's 'Pride and Prejudice' has 92000 words and is divided into 61 chapters. 
# Create an object 'words' for the number of words and an object 'chapters' for the number of chapters. 
# Now create a third object 'words_per_chapter' that stores the average number of words per chapter.
# What is the mean length of a chapter in Pride and Prejudice? Show the mean length by putting the 
# assignment operation in brackets.

words <- 92000
chapters <- 61
(words_per_chapter <- words / chapters)


# Imagine my source had gotten it wrong. Pride and Prejudice actually has 81000 words. 
# Overwrite your original 'words' object and assign it the correct number.
# Again, show the value of 'words_per_chapter' in the console, this time using a different 
# method than you did above. Has it changed? Why/why not?

words <- 81000
words_per_chapter



# Exercise 2.2 --------------------------------
# Test the above claim by creating a cats2 object, which is identical to the cats object,
# but this time, wrap every word in single quotation marks. Then evaluate whether the two objects
# are identical using the == operator. What is the output?

cats2 <- c('Max', 'Catherine', 'Toto')
cats == cats2


# Exercise 2.3 --------------------------------
# Using the c() function, create and display an object 'a' for the numbers 2, 7 and 34 (e.g. three 'double' vectors). 
# Then create and display a new object 'b' for a * 2.
# Observe how the multiplication worked with an object with multiple numbers. 
# Answer the questions below without running any code. 
# Then check your answers programatically. 
# 1) Do a and b have the same type and length? 
# 2) What is the output of a == b? Why?
# 3) What is the output of b > a? Why?

# e.g.
(a <- c(2, 7, 34))
(b <- a * 2)

# 1) yes and yes
typeof(a)
typeof(b)

length(a)
length(b)

# 2) FALSE FALSE FALSE
a == b

# 3) TRUE TRUE TRUE
b > a




# Exercise 2.4 -----------------------------------------
# Have a closer look at the head function (using ?head). 
# Find out how you can display only the first two rows of data. 

head(booker_2000s, n = 2)




# Exercise 2.5 --------------------------------------------
# Now that you know how to select certain rows and columns, you can use that to create new data frames.
# Create a new dataframe 'booker_20000_5 for the years 2000 to 2005, keeping only the first two columns.

booker_2000_5 <- booker_2000s[1:6, 1:2]




# EXTRA EXERCISE (time permitting) ---------------------
# Install and load the package "cowsay" (using the install.packages() and library() functions).
# Google the package to see what functions it has. 
# Pick an animal and make it say something.
# Now pick a different animal and make it tell you the time.

# Install the package
install.packages("cowsay")

# Load it
library(cowsay)

# Use the say() function, supplying first, the string to be 'said', then one of the 
# animals available
say("more food, human", 'cat')

# Passing "time" to the function will automatically print the current time
# (instead of printing the string "time")
say("time", "buffalo")


