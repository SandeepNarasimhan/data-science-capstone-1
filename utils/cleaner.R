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
    if (file.exists(file_path)){
        
        connection = file(file_path)
        lines = readLines(connection, encoding = 'UTF-8', skipNul = TRUE)
        close(connection)
        
    } else {
        
        words_to_remove = get_profanity_words()
        cluster = makeCluster(cpu_core_qty)
        registerDoParallel()
        
        print("Sent Detect")
        ptime <- system.time({
            lines <- foreach(line = lines, .combine = c, .export = 'sent_detect') %dopar% {
                sent_detect(line, language = "en", model = NULL)
            }
        });
        print(ptime)
        
        print("To Lower")
        ptime <- system.time({
            lines <- foreach(line = lines, .combine = c, .export = 'toLower') %dopar% {
                toLower(line)
            }
        });
        print(ptime)        
        
        print("Tokenize")
        ptime <- system.time({
            tokens <- foreach(
                line = lines, 
                .combine = c, 
                .export = c(
                    'tokenize',
                    'words_to_remove',
                    'removeFeatures'
                )) %dopar% {
                    removeFeatures(
                        tokenize(
                            line, 
                            ngrams = 1, 
                            what = "word", 
                            removeNumbers = TRUE, 
                            removePunct = TRUE, 
                            removeSeparators = TRUE,
                            removeTwitter = TRUE, 
                            removeHyphens = TRUE, 
                            removeURL = TRUE 
                        ),
                        words_to_remove
                    )
                }
        });
        print(ptime)    
        
        stopCluster(cluster)
        
        print("Unlist Tokens")
        ptime <- system.time({
            lines = unlist(lapply(tokens, function(x) paste(x, collapse = " ")))
        });
        print(ptime)    
        
        save_clean_data_to_cache(lines, scope)
    }
    lines
}

