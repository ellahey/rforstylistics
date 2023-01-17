#### Session 3 Exercise solutions ####

# 1.

nrow(austen) # returns the number of rows in the dataframe
ncol(austen) # returns the number of columns in the dataframe
names(austen)# returns the variables (column names) in the dataframe
summary(austen) # returns a summary of the dataframe
str(austen) # returns a description of the structure of the dataframe

unique(austen_cleantidy$book) # Returns all unique values for a variable column 
# (in this case, the titles of the 6 novels in the dataframe)

# 2.

(x <- filter(austen_cleantidy, book == "Emma"))
# Filter allows you to subset a dataframe based on specific values within 
# variables. Here we create a new object 'x' which contains only those rows in the
# 'book' column which contain the value "Emma").
