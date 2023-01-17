# --------------------------------------------------
## Session 2: R Basics
# --------------------------------------------------

# In this session, we will cover the following:
# doing simple math
# objects
# functions
# vectors and data frames
# functions
# subsetting
# commenting
# loading libraries
# getting help / reading documentation


# Getting Started ----------------------------------
# Start by creating a new script (File > New File > R Script). Save it in the "Scripts" folder 
# of your working directory and give it a descriptive name (I've called mine Session2)


# Simple Maths ------------------------------------
# R can do the job of a calculator. 

1+1
2-1
4/2
4*2


# Objects ------------------------------------------
# We can also store values and associate them with particular names. 
# Through associating values with variable names, we create what are known in R as 'objects'.
# In other programming languages, variables and objects are different things. In R however, 
# every variable is automatically also an object. In this workshop, we will be using 'variable' and 
# 'object' interchangeably. 
# We create objects by using the assignment operator '<-'. 
# (PC: alt + - / Mac: option + -)

x <- 2
y <- 3 + 1
x
y

# It is also permissible to use the equal sign (=) for assignment.

number = 2
number

# It works just the same way. However, it is generally considered better to use <-, because the equal sign
# also has other 'jobs', as we will see later. 

# Once we have created objects, we can use them in our code to 'stand for' the values assigned to them.
# For example, instead of writing '4-2' we can now achieve the same by computing x - y:

y - x
z <- x + y

# If you run the above code, you will notice that assignment alone (the line where we create 'z') 
# does not show you the value of z in the console. 
# There are 3 main ways for the value of an object to be displayed in the console:
# - type the name of the object and run
# - wrap the assignment statement in parentheses 
# use the print() function

z
(z <- x + y)
print(z)

# We will talk a bit more about functions later on in this session. But basically, functions allow
# you to do stuff with your data. In this case, the function print will pretty much do what it says,
# namely print the object you have passed to it in the console. 
# You use functions by writing the function name followed by parentheses. In those parentheses, you put 
# the object that you want the function to work on. 

# Once you have created an object, it will show up in your environment. 
# Check the 'Environment' tab for the objects x, y and z.

# The association between the name of an object and a particular value however, is not set in stone. 
# We can 'overwrite' them (and this happens quite a lot when working on projects). 
# Run the code below to see what 'overwriting' looks like. 

z 
z <- z + 2*z
z

# If you want to remove an object (to avoid confusion and save space for example), you can use
# the remove() function. 
remove(z)

# You can also shorten this function to just rm(). Try running the statement below. What happens?
rm(z)

# There are a few rules and style guidelines when naming things in R. 
# Object names should be concise and descriptive, so that other people (and your future self) 
# understand what is going on.
# Variable names in R can contain letters, numbers and underscores. 
# They cannot contain any other symbols. They also cannot begin with a number. 
# It is often recommended that you use only lowercase
# letters. If you do use uppercase letters, remember that R is case-sensitive. 
# Let's have a look at some object names:

VariableName <- 5 ## this is allowed, but a bit hard to read
variable_name <- 10 ## this is easier to read
months_year <- 12  ## easy to read and descriptive

aridiculouslylongobjectnamefordemonstrationpurposes <- 10 ## this is pretty bad
20 / aridiculouslylongobjectnamefordemonstratinpurposes ## and this illustrates why


# Exercise 2.1 --------------------------------
# Jane Austen's 'Pride and Prejudice' has 92000 words and is divided into 61 chapters. 
# Create an object 'words' for the number of words and an object 'chapters' for the number of chapters. 
# Now create a third object 'words_per_chapter' that stores the average number of words per chapter.
# What is the average length of a chapter in Pride and Prejudice (words of the book divided by the number of chapters)? 
# Show the average length by putting the assignment operation in parentheses.



# Turns out I got this from a dodgy source. Pride and Prejudice actually has 81000 words. 
# Overwrite your original 'words' object and assign it the correct number of words.
# Again, show the value of 'words_per_chapter' in the console, this time using a different 
# method than you did above. Has it changed? Why/why not?




# 2.Data Structures -------------------------------
# So far, we have worked with numbers. In R, these are encoded as vectors. 
# Aside from numeric vectors, as the ones we've seen above, there are various other types.

# Vectors 
# Vectors are the most basic data structure in R. Above, we have already worked with them. 
# x, y and z are all vectors. More specifically, they are vectors of the mode 'double'. 
# Other than 'double', we will cover 2 more types of vectors: 

# - double (2.56, 10, 1987.1368439)
# - character ("cat", "To Kill A Mockingbird")
# - logical (TRUE, FALSE)

# Every vector has two key properties: a type and a length. There are functions of the same name
# that tell us the type and length of a variable of interest. 
#Let's try these with the variables we created previously:

typeof(x)
length(x)


# Let's take a closer look at logical and character vectors now. 
# Logical vectors can only be TRUE, FALSE or NA (unknown). 
# Logical vectors usually show up when we use Boolean operators to test how objects relate to each other. 
# Two equal signs (==) test for equality, != tests for non-equality, 
# < or > test for bigger/smaller than.

typeof(x) == typeof(y)
x == y
x != y
x > y
y > x



# And finally: character vectors
# Seeing as we will be working a lot with text, character vectors are quite important for us.
# We can create character vectors by wrapping letters or words in quotation marks, like this:

favorite_cat <- "Theodore the Great"
typeof(favorite_cat)
length(favorite_cat)


# So far we have only created variables with single values. We can use the c() function to store 
# multiple elements in one object.

cats <- c("Max", "Catherine", "Toto")

typeof(cats)
length(cats)

# To create character vectors, you can wrap your words, phrases, sentences etc. into single or 
# double quotation marks, to R, it doesn't make a difference. 

# Exercise 2.2 --------------------------------
# Test the above claim by creating a cats2 object, which is identical to the cats object,
# but this time, wrap every word in single quotation marks. Then evaluate whether the two objects
# are identical using the == operator. What is the output?



# Okay, we have seen that both single and double quotation marks work. What matters is that you
# use the same ones at the beginning and end of the phrase, and more importantly, 
# that you use them at all. 
# What happens if we forget quotation marks?

cats <- c("Max", catherine, "Toto")

# Note that if we display 'cats' again, we still get the same as before. This is because the error
# message means that cat couldn't be overwritten. 
# However, this suggests that we can add existing objects to the other elements using the c() function.
# This is good news, because it turns out, we forgot Theodore in our list of cats. 
# Let's add him.

cats <- c(cats, favorite_cat)


# Exercise 2.3 --------------------------------
# Using the c() function, create and display an object 'a' for the numbers 2, 7 and 34 (e.g. three 'double' vectors). 
# Then create and display a new object 'b' for a * 2.
# Observe how the multiplication worked with an object with multiple numbers. 
# Answer the questions below without running any code. 
# Then check your answers programatically. 
# 1) Do a and b have the same type and length? 
# 2) What is the output of a == b? 
# 3) What is the output of b > a



# Another handy thing we can do is create sequential numbers using the : operator.

serial_numbers <- c(1:12)
serial_numbers

# Once we are working with a bunch of data, functions like min(), max() and mean() are a very
# simple and quick way of getting a better idea of our data.

min(serial_numbers)
max(serial_numbers)
mean(serial_numbers)

# Let's see what happens if we have a missing data point in our data. 
# First, we manufacture a missing data point by adding 'NA' to our serial_numbers vector.
(serial_numbers <- c(serial_numbers, NA))

# Now, let's re-run the min(), max() and mean() functions.

min(serial_numbers)
max(serial_numbers)
mean(serial_numbers)


# Okay. As soon as there are missing values, the min(), max() and mean() functions will return NA.
# That's probably not how we'd want this to go if we had missing data. Really what we would want
# is for the function to ignore the 'NA'. We can see whether the functions provide a way for doing that
# by reading their R documentation. We can quickly access a function's documentation like this:

?min
?mean

# # Min(), max() and mean() all have a logical parameter called na.rm that we can set to TRUE ('turn it on'), or FALSE
# ('turn it off'). As we have seen, the default is for na.rm to be set to FALSE. If we set it to TRUE, the
# function will remove NA values, meaning it will ignore any missing values. So let's try that:

min(serial_numbers, na.rm = TRUE)
max(serial_numbers, na.rm = TRUE)
mean(serial_numbers, na.rm = TRUE)

# That works. Note that the same applies for evaluating boolean operations with NA values. 
w <- NA
x == w

# But now on to:

# Data Frames ------------------------------------------
# Data frames are probably the data structure you will be working with the most. Essentially,
# data frames are like tables.
# They have rows and columns, where the columns are vectors of the same length. 
# Data frames are mostly created by reading in data (something we will do in the next session). 
# For now though, let's create a data frame 'by hand'. 
# We're going to create a data frame for the Booker prize winners of the 2000s, including 
# the title of the book, the author, and the year they won. 
# First, let's create a vector for each column we want.

?data.frame

books <- c("The Blind Assassin", "True History of the Kelly Gang", "Life of Pi", "Vernon God Little", "The Line of Beauty", "The Sea", "The Inheritance of Loss", "The Gathering", "The White Tiger", "Wolf Hall")
authors <- c("Margaret Atwood", "Peter Carey", "Yann Martel", "DBC Pierre", "Alan Hollinghurst", "John Banville", "Kiran Desai", "Anne Enright", "Aravind Adiga", "Hilary Mantel")
won_year <- c(2000:2009)

# Now we can combine these vectors into a data frame by using the data.frame() function.
# We need to specify the names of the columns and pass the data of the vectors we've just created.
booker_2000s <- data.frame(col1 = authors, col2 = books, col3 = won_year)

# Let's have a look
booker_2000s

# Run the code below. What do the head() and tail() functions do?
head(booker_2000s)
tail(booker_2000s)


# Exercise 2.4 -----------------------------------------
# Have a closer look at the head function (using ?head). 
# Find out how you can display only the first two rows of data. 


# Indexing and Subsetting ------------------------------
# There are several ways of indexing or selecting specific parts of a data frame. 
# Knowing how to select rows and columns is incredibly useful.
# One way of specifying them is by using square brackets [] and 
# what we can think of as the 'coordinates' of rows and columns (with the row number coming first).

# So if we want to access the data in the 3rd row in the 2nd column, we can write:

booker_2000s[3, 2]
booker_2000s

# If we leave either of those empty, we either get the 3rd row with all it's columns or all rows
# for the specified column. 
booker_2000s[3, ]
booker_2000s[ , 2]

# Now we also have a different way of looking at the first few rows of our data frame. 
# Remember that head() as a default gives us the first 5 rows of a data frame. We could achieve the 
# same thing now writing

booker_2000s[1:5, ]


# Another way of indexing columns is using the dollar sign $ in conjunction with the column name.
# To get all of column 2, we can also write
booker_2000s$col2


# Exercise 2.5 --------------------------------------------
# Now that you know how to select certain rows and columns, you can use that to create new data frames.
# Create a new dataframe 'booker_20000_5 for the years 2000 to 2005, keeping only the first two columns.



# Another very useful function when working with data frames is glimpse(), which is part of the dplyr package. 
# So far, all the functions we have worked with were 'base R' functions, 
# meaning the come pre-installed when you download R. 
# There are however, many more useful functions out there. You can get them through packages/libraries.
# You have already installed the dplyr package in your preparation for the workshop. 
# Let's load it so we can use glimpse().

# We load a previously installed package using library(). 
library(dplyr)

# Now we can use the glimpse() function on our booker_2000s dataframe.
glimpse(booker_2000s)

# What information do we get from glimpse that we don't get from head() or tail()?



# EXTRA EXERCISE (time permitting) ---------------------
# Install and load the package "cowsay" (using the install.packages() and library() functions).
# Google the package to see what functions it has. 
# Pick an animal and make it say something.
# Now pick a different animal and make it tell you the time.





