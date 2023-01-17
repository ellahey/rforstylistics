#### Session 5: Webscraping ####

library(tidyverse)
library(rvest)
library(polite)
library(httr)

# In this session we'll learn how to scrape text from the web. Let's imagine we wanted
# to analyse the novel White Fang, by Jack London. This is available online at 
# https://www.online-literature.com/london/whitefang/. 

# Before we scrape any website, it is important to ensure that the site permits 
# scraping, as not all sites do. The **polite** package lets us check whether we
# are permitted to scrape a url. 

# The first step is to save the url as an object in our environment:

url <- "https://www.online-literature.com/london/whitefang/"

# Next, we check the site permissions, using the polite function `bow`. The result 
# we're looking for is "The path is scrapable for this user-agent".

(url_bow <- bow(url))

# We're good to go.
# Next, we combine the `bow` function with `scrape` to pull the site's html structure:

url <-  bow(url) %>%
  scrape()

# If we now inspect the 'url' object, we see that we don't have the site text, but
# the html code that was used to build it. This is what we will use to extract the
# content we want.

# The text of White Fang is organized per chapter, each of which is linked from the sidebar
# of the url we have just scraped. In order to extract the text of the relevant chapters,
# we need to first extract each individual chapter link, and then tell R to pull
# the text from the corresponding pages. We do this by inspecting the site's html
# code and figuring out exactly which code corresponds to which content. 

# Go back to the White Fang url (https://www.online-literature.com/london/whitefang/) and
# right click anywhere on the page. Then select 'Inspect' from the menu (this is the 
# process in Chrome on a Windows machine; the process for Mac/Safari might be different).

# We need to tell R to drill down through the structure of the html to isolate the
# content we want. In this case what we want are the links to all of the
# chapters.

urls <- url %>% # this code block = "drilling down"
  html_nodes("div.col-md-3.col-md-pull-9.col-lg-3.col-lg-pull-9") %>%
  html_nodes("div.panel") %>%
  html_nodes("div.panel-body") %>%
  html_nodes("ul") %>%
  html_nodes("li") %>%
  html_nodes("a") %>%
  html_attr("href")


# <div> = a document section
# <ul> = an unordered, bulleted list
# <li> = a list
# <a> = a link
# <href> = the url that a link goes to. <href> is an attribute of the <a> node.
  

# We should now have a vector containing all of the urls for the chapters of
# White Fang. Let's have a look:

urls

# Okay, now we're ready to get the text of the individual chapters. Since
# scraping large amounts of text can take some time, it's good to first try out 
# our code on a test case to make sure it works.

# Let's take our Chapter 1 url and save it as a new object, which we'll call 'test':

test <- urls[1]
test

# Now, we'll use the same procedure we used above to scrape the text portion of this
# url. Getting the text of a page usually requires the <p> html node,
# so without even inspecting the page html I can run the code below and be fairly 
# confident I'll get what I need (but note that fancy websites with lots of elements might still
# require closer inspection before determining which nodes to include):

scrape(bow(test)) %>%
  html_nodes("p") %>%
  html_text2() %>% # this function extracts the text portion of the <p> element
  paste(collapse = '\n') # this says to paste all the text together into a single
# character vector nd to separate the lines using 'new line'. To better understand 
# why this step is needed, try running the code above again, but without this last step.

# Right, this has worked beautifully. The next step, then, is to apply this method
# to all of our chapter urls, and to save the scraped text in a dataframe.

# In what follows I'll be working with a type of dataframe called a "tibble". We've
# been working with tibbles already in this workshop, but without realizing it,
# because a tibble is the default dataframe type used by `tidyverse` functions.
# I won't get into the details of what tibbles are and how they differ from other types of 
# dataframes, but you can read about this on your own at: https://r4ds.had.co.nz/tibbles.html

# I'm going to create a tibble (I'll call it "scrape_tibble"), which contains
# the urls of the individual chapters as the first variable, and which will include a 
# second column in which we will place the the text of each of the
# chapters. We do this before we scrape the chapter text so we have a convenient
# dataframe container in which to put the text once we extract it. 

scrape_tibble <- tibble( # create a tibble called 'scrape_tibble'
  "url" = urls, # the first column will be called 'url' and will contain the urls we obtained earlier 
  "text" = NA # the second column will be called 'text' and the values will be NA
)

# Let's inspect our new dataframe, which for now just consists of urls and NA values for 
# "text":
scrape_tibble

# Now we need to go get our text. To do this, we need to tell R to scrape each of 
# the individual urls we just placed in our "scrape_tibble" and to put the resulting
# text in the "text" column of that same tibble. This requires us to use a loop function.
# We'll use a type of loop called a "for-loop". These take the structure:

# `for (item in vector) perform_action`

# We can see how a for-loop works in practice by creating a very simple one:
for (i in 1:3) { # for each item in the series of values 1-3
  print(i)       # print that value
}

# [1] 1
# [1] 2
# [1] 3

# We can apply the same logic to scraping our chapter urls:


for (i in 1:25) {      # for each item in the series of values 1-25
  scrape_tibble[i,2] <- scrape(bow(urls[i])) %>% # assigns column 2 as the target
    html_nodes("p") %>%  # extract node "p" (paragraph)
    html_text2()%>%      # get the text elements within the <p> node
    paste(collapse = '\n') # paste into column 2 and collapse lines using '\n' (line break)
}

# Let's look at the first result. We'll again save this as a separate object so we
# can test out any cleaning on this before applying to all of our text.

(one <- scrape_tibble$text[1])

# There is some header and footer text that we would probably want to remove. Again
# we'll need to use regex to do this. We can use 'str_remove_all' from the **stringr**
# package and specify that we will use regex:

one %>%
  str_remove_all(regex("Literature.+Chapter\\s\\d", dotall = F))

one %>%
  str_remove_all(regex("Languages: English.+Sites", dotall = T))

# dotall tells the `regex` function that the . should match everything, including
# \n (new line). If we have dotall = T in the first str_remove_all code, 
# we'll delete the entire chapter!


# This works. Apply to the entire tibble:
scrape_tibble$text <- scrape_tibble$text %>%
  str_remove_all(regex("Literature.+Chapter\\s\\d", dotall = F)) %>%
  str_remove_all(regex("Languages: English.+Sites", dotall = T))

scrape_tibble

# We now have the entire text of White Fang saved chapter-by-chapter in a dataframe.
# We can now work further with this in R, or export it to another piece of software
# for further analysis! For now let's write it to disk because we'll be using it
# again in Session 7. Sara will explain more about writing to disk in Session 8 -
# for now, the code below should do the trick if you've organized your folders 
# the way I showed you in Session 1:

write_csv(scrape_tibble, "Data/wf.csv")



#### EXERCISE ####

# 1. Scrape the text of the following article on Dickens from The Guardian:
# https://www.theguardian.com/books/2022/dec/21/where-to-start-with-charles-dickens

# 2. How would you scrape the headline?
# 3. Now see if you can figure out how to combine the text and headline into a single
# string.
# 4. Finally, create a dataframe with two variables -- 'url' and 'text'. Store the
# url of the article page in the 'url' column and the text of the article in the 
# text column.

