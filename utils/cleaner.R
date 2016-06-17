source('utils/requirements.R')
source('utils/data.R')
prepare_data()

cut_into_sentences = function(lines){
    lines = sent_detect(lines, language = "en", model = NULL)
    lines
}


get_clean_file_path = function(scope){
    ensure_dir_exists(clean_folder_name)
    file_name = paste(c(scope, "txt"), collapse = ".")
    file_path = paste(c(clean_folder_name, file_name), collapse = "/")
    file_path
}

save_clean_data_to_cache = function(data, scope = "sample"){
    
    file_path = get_clean_file_path(scope)
    if (file.exists(file_path)){
        file.remove(file_path)
    }
    connection = file(file_path)
    writeLines(data, connection)
    close(connection) 
}

clean_data = function(lines, scope = 'sample'){
    
    file_path = get_clean_file_path(scope)
    print(file_path)
    if (file.exists(file_path)){
        
        connection = file(file_path)
        lines = readLines(connection, encoding = 'UTF-8', skipNul = TRUE)
        close(connection)
        
    } else {
        lines = cut_into_sentences(lines)
        
        profanity_words = scan("dictionary/profanity.txt", what = "character", sep = "\n")
        
        lines.corpus = Corpus(VectorSource(lines))
        lines.corpus = tm_map(lines.corpus, content_transformer(tolower), mc.cores = 4)
        lines.corpus = tm_map(lines.corpus, removePunctuation, mc.cores = 4)
        lines.corpus = tm_map(lines.corpus, removeNumbers, mc.cores = 4)
        lines.corpus = tm_map(lines.corpus, removeWords, stopwords("english"), mc.cores = 4)
        lines.corpus = tm_map(lines.corpus, removeWords, profanity_words, mc.cores = 4)
        
        lines = gsub(
            "\\s\\s+",
            " ",
            unlist(
                sapply(lines.corpus, `[`, "content")
            )
        )
        save_clean_data_to_cache(lines, scope)
    }
    lines
}
