#### Session 7 Exercise solutions ####

# 1.
freq_verbs <- selection %>%
 filter(upos == "VERB") %>%
  count(token) %>%
  arrange(desc(n))

freq_verbs[1:20,] %>%
  ggplot(aes(x = n, y = reorder(token, n))) +
  geom_col (fill = "deepskyblue") +
  labs(title = "Most frequent verbs in White Fang Chs 1-3") +
  xlab("Frequency") +
  ylab("Verb")


# 2. 

selection %>%
  count(upos) %>%
  arrange(desc(n))

# 3. 

freq_nouns[1:20,] %>%
  ggplot(aes(x = n, y = reorder(token, n))) + 
  geom_col (fill = "deepskyblue") +
  labs(title = "Most frequent nouns in White Fang Chs 1-3") +
  xlab("Frequency") +
  ylab("Noun") +
  theme_bw()

freq_nouns[1:20,] %>%
  ggplot(aes(x = n, y = reorder(token, n))) + 
  geom_col (fill = "deepskyblue") +
  labs(title = "Most frequent nouns in White Fang Chs 1-3") +
  xlab("Frequency") +
  ylab("Noun") +
  theme_classic()

freq_nouns[1:20,] %>%
  ggplot(aes(x = n, y = reorder(token, n))) + 
  geom_col (fill = "deepskyblue") +
  labs(title = "Most frequent nouns in White Fang Chs 1-3") +
  xlab("Frequency") +
  ylab("Noun") +
  theme_dark()


  
