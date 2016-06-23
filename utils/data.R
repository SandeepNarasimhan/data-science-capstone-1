data_folder_name = 'data'
samples_folder_name = 'samples'
predictor_cache_folder_name = 'predictor'
downloads_folder_name = 'downloads'
ngrams_folder_name = 'ngrams'
clean_folder_name = 'clean'
download_source = 'https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip'
download_destination_path = paste(c(downloads_folder_name, 'Coursera-SwiftKey.zip'), collapse = "/")
data_files = c('en_US.blogs.txt', 'en_US.news.txt', 'en_US.twitter.txt')
data_names = c('blogs', 'news', 'twitter')

ensure_dir_exists = function(folder_name){
    if (!file.exists(folder_name)){
        dir.create(folder_name)
    }
}

ensure_data_downloaded = function(){
    ensure_dir_exists(downloads_folder_name) 
    
    if (!file.exists(download_destination_path)){
        download.file(download_source, download_destination_path)    
    }
}

is_file_exists = function(file_name){
    file_destination = paste(c(data_folder_name, file_name), collapse = "/") 
    file.exists(file_destination)
}

extract_data_file = function(data_file){
    print(paste(c('No data file', data_file, 'extracting...'), collapse = " "))
    list_of_files = unzip(download_destination_path, list = TRUE)
    for (file in list_of_files$Name){
        if (grepl(data_file, file)){
            file_to_extract = file
            
            unzip(
                download_destination_path, 
                files = file_to_extract,
                exdir = data_folder_name,
                junkpaths = TRUE
            )
        }
    }
}

ensure_data_file_exists = function(data_file){
    if (!is_file_exists(data_file)){
        extract_data_file(data_file)
    }
}

ensure_data_unzipped = function(){
    ensure_dir_exists(data_folder_name)
    for (data_file in data_files){
        ensure_data_file_exists(data_file)
    }
}

prepare_data = function(){
    ensure_data_downloaded();
    ensure_data_unzipped();
}

prepare_sample = function(name){
    sample_size = 0.01
    file_name = paste(c('en_US', name, 'txt'), collapse = ".")
    file_path = paste(c(samples_folder_name, file_name), collapse = "/") 
    print(file_path)
    if (!file.exists(file_path)){
        lines <- get_data('news')
        lines.sample = lines[
            sample(
                1:length(lines), 
                round(length(lines) * sample_size)
            )
        ]
        connection = file(file_path)
        writeLines(lines.sample, connection)
        close(connection) 
    }
}

prepare_sample_files = function(){
    ensure_dir_exists(samples_folder_name)
    foreach(i = data_names) %do%
        prepare_sample(i)        
}

get_data = function(type){
    file_name = paste(c('en_US', type, 'txt'), collapse = ".")
    file_path = paste(c(data_folder_name, file_name), collapse = "/")
    connection = file(file_path)
    data.lines = readLines(connection, encoding = 'UTF-8', skipNul = TRUE)
    close(connection)
    data.lines
}

get_sample = function(name){
    file_name = paste(c('en_US', name, 'txt'), collapse = ".")
    file_path = paste(c(samples_folder_name, file_name), collapse = "/") 
    connection = file(file_path)
    sample.lines = readLines(connection, encoding = 'UTF-8', skipNul = TRUE)
    close(connection)
    sample.lines
}

get_profanity_words = function() {
    connection = file("dictionary/profanity.txt")
    lines = readLines(connection, encoding = 'UTF-8', skipNul = TRUE)
    close(connection)
    lines
}

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
