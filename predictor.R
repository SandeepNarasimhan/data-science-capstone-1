source('utils/requirements.R')
source('utils/data.R')
prepare_data()
source('utils/cleaner.R')
source('utils/ngrams.R')
# prepare_sample_files()

if (!is_ngrams_ready(ngrams_n)){
    lines = get_combined_data()
    clean.lines = clean_data(lines)
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

print(head(predict("The guy in front of me just bought a pound of bacon, a bouquet, and a case of")))

print(head(predict("You're the reason why I smile everyday. Can you follow me please? It would mean the")))

print(head(predict("Hey sunshine, can you follow me and make me the")))

print(head(predict("Very early observations on the Bills game: Offense still struggling but the")))

print(head(predict("Go on a romantic date at the")))

print(head(predict("Well I'm pretty sure my granny has some old bagpipes in her garage I'll dust them off and be on my")))

print(head(predict("Ohhhhh #PointBreak is on tomorrow. Love that film and haven't seen it in quite some")))

print(head(predict("After the ice bucket challenge Louis will push his long wet hair out of his eyes with his little")))

print(head(predict("Be grateful for the good times and keep the faith during the")))

print(head(predict("If this isn't the cutest thing you've ever seen, then you must be")))



# print(clean.lines)

