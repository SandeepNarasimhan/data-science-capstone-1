source('utils/requirements.R')
source('utils/data.R')

prepare_sample_files()

get_combined_sample = function(){
    blogs.sample.lines = get_sample('blogs')
    twitter.sample.lines = get_sample('twitter')
    news.sample.lines = get_sample('news')
    sample.lines = c(blogs.sample.lines, twitter.sample.lines, news.sample.lines)
    rm(blogs.sample.lines)
    rm(twitter.sample.lines)
    rm(news.sample.lines)
    sample.lines
}

sample.lines = get_combined_sample()

sample.corpus <- corpus(sample.lines)
words_to_remove = c(stopwords("english"), get_profanity_words())
sample_1_grams <- dfm(sample.corpus, ngrams = 1, what = "word", 
                  removeNumbers = TRUE, removePunct = TRUE, removeSeparators = TRUE,
                  removeTwitter = TRUE, removeHyphens = TRUE, 
                  ignoredFeatures = words_to_remove, stem=TRUE)

sample_2_grams <- dfm(sample.corpus, ngrams = 2, what = "word", 
                      removeNumbers = TRUE, removePunct = TRUE, removeSeparators = TRUE,
                      removeTwitter = TRUE, removeHyphens = TRUE, 
                      ignoredFeatures = words_to_remove, stem=TRUE)

sample_3_grams <- dfm(sample.corpus, ngrams = 3, what = "word", 
                      removeNumbers = TRUE, removePunct = TRUE, removeSeparators = TRUE,
                      removeTwitter = TRUE, removeHyphens = TRUE, 
                      ignoredFeatures = words_to_remove, stem=TRUE)
