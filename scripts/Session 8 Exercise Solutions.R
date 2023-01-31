# --------------------------------------------------
## Session 8: Exercise Solution
# --------------------------------------------------

# Exercise 8.1 -------------------------------------
# For the last exercise of this workshop, write the Guardian article
# about Charles Dickens you scraped for the exercise in Session 5 to your
# disk as a .txt file. 
# (If you have cleared your environment since scraping the article,
# you may need to re-run your code from the exercise in Session 5.
# Alternatively, you can use Ernestine's code from the Session 5
# solution script on GitHub).

# Note: this code is based on the Session 5 Exercise solution script
# Depending on what you have named your objects when completing the
# exercise from Session 5, you will need to adjust the code below.

# We already have an object ("complete") containing all the article 
# paragraphs in one character vector. 

# Inspect
complete

# We can again use the write.table() function to write the text
# to a .txt file. 
write.table(complete, "GuardianCharlesDickens.txt")

# Check if it worked:
list.files()