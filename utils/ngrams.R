source('utils/requirements.R')
source('utils/data.R')
prepare_data()

ngrams_n = 2:5
words_to_remove = c(get_profanity_words(), stopwords('english'))

get_ngrams_file = function(ngrams_n){
    paste(c(ngrams_n, "RDS"), collapse = ".")
}

get_short_ngrams_path = function(ngrams_n, first_sign, second_sign = "_"){
    ngrams_file = get_ngrams_file(ngrams_n)
    paste(c(ngrams_folder_name,  first_sign, second_sign, ngrams_file), collapse = "/")
}

get_ngrams_path = function(ngrams_n){
    ngrams_file = get_ngrams_file(ngrams_n)
    paste(c(ngrams_folder_name, ngrams_file), collapse = "/")
}

get_ngrams = function(ngrams_n){
    global_var_name = paste(c("ngram", ngrams_n), collapse = "_")
    if (!exists(global_var_name)){
        ngrams_path = get_ngrams_path(ngrams_n)
        assign(global_var_name, readRDS(ngrams_path), envir = .GlobalEnv)    
    }
    get(global_var_name)
}

save_short_ngrams = function(df, ngrams_n, first_sign, second_sign = "_"){
    ensure_dir_exists(ngrams_folder_name)
    ngrams_path = get_short_ngrams_path(ngrams_n, first_sign, second_sign)
    if (file.exists(ngrams_path)){
        file.remove(ngrams_path)
    }
    saveRDS(df, ngrams_path)   
}

save_ngrams = function(df, ngrams_n){
    ensure_dir_exists(ngrams_folder_name)
    ngrams_path = get_ngrams_path(ngrams_n)
    if (file.exists(ngrams_path)){
        file.remove(ngrams_path)
    }
    saveRDS(df, ngrams_path)
}

is_ngrams_ready = function(ngrams_n){
    ready = TRUE
    for (n in ngrams_n){
        ngrams_path = get_ngrams_path(n)
        if (!file.exists(ngrams_path)){
            ready = FALSE
        }
    }
    ready
}

split_to_sentences = function(lines){
    print("Split to sentences")
    timer = system.time({
        sentences = unlist(lines %>% regexp_tokenizer(pattern = '[\\.\\?\\!]+'))    
    })
    print(timer)
    sentences
}

get_tokens = function(lines, scope = 'sample'){
    print("Preparing Tokens")
    timer = system.time({
        tokens = itoken(
            split_to_sentences(lines), 
            preprocess_function = tolower, 
            tokenizer = word_tokenizer, 
            chunks_number = 10, 
            progessbar = TRUE
        )
    })
    print(timer)
    tokens
}

prepare_ngrams = function(lines, ngrams_n){
    
    print("Tokenize n-grams")
    
    for (n in ngrams_n){
        print(paste(c("Prepare", n, "grams"), collapse = " "))
        timer = system.time({
            tokens = get_tokens(lines)
            vocab = create_vocabulary(tokens, c(n, n), stopwords = words_to_remove)
            vocab = prune_vocabulary(vocab, term_count_min = 2)
            save_ngrams(vocab$vocab, n)  
            rm(vocab)
            rm(tokens)
        }) 
        print(paste(c("Done", n, "grams"), collapse = " "))
    }
}

# transform_ngram_into_short = function(ngrams_n){
#     
#     
#     df = get_ngrams(ngrams_n)
#     
#     
#     print(head(df))
#     
#     
#     
#     
#     
# }
# 
# transform_ngrams_into_short = function(){
#     for (n in ngrams_n){
#         transform_ngram_into_short(n)
#     }    
# }
# 
