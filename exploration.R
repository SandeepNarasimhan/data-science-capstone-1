source('utils/requirements.R')
source('utils/data.R')

prepare_data()

twitter.lines = get_data('twitter')
blogs.lines = get_data('blogs')
news.lines = get_data('news')


