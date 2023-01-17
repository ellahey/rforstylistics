#### Session 5 Exercise Solutions ####

guardian_url <- "https://www.theguardian.com/books/2022/dec/21/where-to-start-with-charles-dickens"

bow(guardian_url)

guardian_html <- bow(guardian_url) %>%
  scrape()

txt <- guardian_html %>%
  html_nodes("p") %>%
  html_text() 

# Inspect:
txt

# Looks good; some strings need cleaning, but we have the text. 
# Let's get the article headline. This is almost always going to be stored in 
# "h1" tags.

header <- guardian_html %>%
  html_nodes("h1") %>%
  html_text() 

# We can combine them into a single vector:

complete <- c(header, txt)

# We can store them in a dataframe:
guardian_df <- tibble(
  url = guardian_url,
  text = complete
)
guardian_df



