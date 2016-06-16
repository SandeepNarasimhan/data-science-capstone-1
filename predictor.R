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
