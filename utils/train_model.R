source('utils/requirements.R')
source('utils/data.R')
prepare_data()
source('utils/ngrams.R')
# prepare_sample_files()

trained_model_folder = 'trained_model'
trained_model_file_name = 'trained_model.Rdata'

get_trained_model_file_path = function(){
    trained_model_folder
}

get_trained_model_file_name = function(){
    paste(c(trained_model_folder, trained_model_file_name), collapse = "/")
}

ensure_trained_model_folder = function(){
    ensure_dir_exists(get_trained_model_file_path())    
}

save_trained_model = function(trained_model){
    ensure_trained_model_folder()
    save(trained_model, file = get_trained_model_file_name())
}

load_trained_model = function(){
    load(get_trained_model_file_name)
}

is_model_trained = function(){
    file.exists(get_trained_model_file_name())
}

get_levels_vector = function(lines){
    tokens = get_tokens(lines)
    vocab = create_vocabulary(tokens, c(1, 1), stopwords = words_to_remove)
    unique(vocab$vocab$terms)
}

get_ngrams_vocabluary = function(lines){
    tokens = get_tokens(lines)
    vocab = create_vocabulary(tokens, c(min(ngrams_n), max(ngrams_n)), stopwords = words_to_remove)
    vocab = prune_vocabulary(vocab, term_count_min = 2)
    vocab$vocab
}

train_model = function(){
    
    lines = get_combined_sample()
    
    # I will reuse tokenize methods from utils/ngrams.R
    print("Preparing Levels")
    levels = get_levels_vector(lines)
    
    print("Preparing Ngrams")
    ngrams_vocab = 
        get_ngrams_vocabluary(lines) %>% 
        arrange(desc(terms_counts))
    
    print("Split N-Grams into Vectors")
    timer = system.time({

        
        ngram_vector = 
            strsplit(ngrams_vocab$terms, "\\_") %>%
            lapply(function(vec){
                vec[which(vec != "")]
            }) %>%
            lapply(function(vec){ 
                times = max(ngrams_n) - length(vec)
                if (times > 0){
                    c(rep(NA, times), vec)   
                } else {
                    vec
                }
            }) %>% 
            unlist
        
        train_df = as.data.frame(matrix(ngram_vector, byrow = TRUE))
            
    })
    print(timer)
    

}


