source('utils/requirements.R')
source('utils/data.R')
prepare_data()

ngrams_n = 2:21

get_ngrams_file = function(ngrams_n){
    paste(c(ngrams_n, "RDS"), collapse = ".")
}

get_ngrams_path = function(ngrams_n){
    ngrams_file = get_ngrams_file(ngrams_n)
    paste(c(ngrams_folder_name, ngrams_file), collapse = "/")
}

get_ngrams = function(ngrams_n){
    ngrams_path = get_ngrams_path(ngrams_n)
    readRDS(ngrams_path)
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

prepare_ngrams = function(list, ngrams_n){
    
    print("Define Words Count")
    ptime <- system.time({
        lines.word.count = unlist(lapply(list, wordcount))    
    })
    print(ptime)
    
    cluster = makeCluster(cpu_core_qty)
    registerDoParallel()
    
    print("Tokenize n-grams")
    ptime <- system.time({
        foreach(
            n = ngrams_n, 
            .export = c(
                'list', 
                'lines.word.count', 
                'ngram',
                'get.phrasetable',
                'save_ngrams'
            )
        ) %dopar% {
            matched.list = list[lines.word.count >= n]
            if (length(matched.list) > 0){
                ngram_tdm = ngram(matched.list, n = n)
                save_ngrams(get.phrasetable(ngram_tdm), n)
                print(paste(c("Done", n, "grams"), collapse = " "))
            } else {
                print(paste(c("Skip", n, "grams due to empty list"), collapse = " "))
            }
        }
    })
    print(ptime)     
    
    stopCluster(cluster)
}
