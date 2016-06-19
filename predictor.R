source('utils/requirements.R')
source('utils/data.R')
prepare_data()
source('utils/cleaner.R')
source('utils/ngrams.R')
prepare_sample_files()

if (!is_ngrams_ready(ngrams_n)){
    sample.lines = get_combined_sample()
    clean.lines = clean_data(sample.lines)
    prepare_ngrams(clean.lines, ngrams_n = ngrams_n)    
}

find_inside_ngrams = function(words, ngrams_n){
    
    required_n = ngrams_n - 1 
    end_index = length(words)
    start_index = end_index - required_n + 1
    search_query = paste(words[start_index:end_index], collapse = " ")
    search_pattern = paste(c("^", search_query, "\\s"), collapse = "")
    ngrams_df = get_ngrams(ngrams_n)
    ngrams_vector = ngrams_df$ngrams
    ngrams_found = ngrams_vector[grep(search_pattern, ngrams_vector)]
    result = str_trim(gsub(search_query, "", ngrams_found))
    result
}

predict = function(phrase){
    
    clean.vector = clean_phrase(phrase)[[1]]
    
    word_count = length(clean.vector)
    min_ngrams = min(ngrams_n)
    max_ngrams = max(ngrams_n)
    
    start_ngrams = min(c(max_ngrams, (word_count + 1)))
    results = c()
    for (n in start_ngrams:min_ngrams){
        results = c(results, find_inside_ngrams(clean.vector, n))
    }
    results
}

###
# Test Predictor 
###

# print(predict("Be grateful for the good times and keep the faith during the"))
# worse
# sad
# bad
# hard

print(predict("If this isn't the cutest thing you've ever seen, then you must be"))
# asleep
# callous
# insensitive
# insane




# print(clean.lines)

