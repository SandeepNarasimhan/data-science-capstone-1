source('utils/requirements.R')
source('utils/data.R')
prepare_data()
source('utils/cleaner.R')

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

get_combined_data = function(){
    blogs.lines = get_data('blogs')
    twitter.lines = get_data('twitter')
    news.lines = get_data('news')
    data.lines = c(blogs.lines, twitter.lines, news.lines)
    rm(blogs.lines)
    rm(twitter.lines)
    rm(news.lines)
    data.lines
}

sample.lines = get_combined_sample()



# ng.sample_1_ngrams = ngram(paste(sample.lines, collapse = " "), 1)
# ng.sample_2_ngrams = ngram(paste(sample.lines, collapse = " "), n = 2)
# ng.sample_3_ngrams = ngram(paste(sample.lines, collapse = " "), n = 3)
# ng.sample_4_ngrams = ngram(paste(sample.lines, collapse = " "), n = 4)
# ng.sample_5_ngrams = ngram(paste(sample.lines, collapse = " "), n = 5)

clean.lines = clean_data(sample.lines)

print(as.character(clean.lines))

