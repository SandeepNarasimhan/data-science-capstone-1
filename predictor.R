source('utils/requirements.R')
source('utils/data.R')
prepare_data()
source('utils/ngrams.R')
# prepare_sample_files()

if (!is_ngrams_ready(ngrams_n)){
    
    print("Load Data")
    timer = system.time({
        lines = get_combined_sample()    
    })
    prepare_ngrams(lines, ngrams_n)
}

find_inside_ngrams = function(words, ngrams_n){
    
    required_n = ngrams_n - 1 
    end_index = length(words)
    start_index = end_index - required_n + 1
    search_query = paste(words[start_index:end_index], collapse = "_")
    search_pattern = paste(c("^", search_query, "_"), collapse = "")
    ngrams_df = get_ngrams(ngrams_n)
    selected_df = select(ngrams_df, starts_with("terms")) %>% 
        filter(grepl(search_pattern, terms)) %>%
        arrange(desc(terms_counts))
    
    selected_df$terms = gsub(paste(c(search_query, "_"), collapse = ""), "", selected_df$terms)
    selected_df$terms
}

predict = function(phrase){
    
    '%nin%' <- Negate('%in%')
    words = unlist(word_tokenizer(phrase))
    words = words[tolower(wordStem(words, language = 'english')) %nin% words_to_remove]
    word_count = length(words)
    min_ngrams = min(ngrams_n)
    max_ngrams = max(ngrams_n)
    
    start_ngrams = min(c(max_ngrams, (word_count + 1)))
    results = c()
    for (n in start_ngrams:min_ngrams){
        results = c(results, find_inside_ngrams(words, n))
    }
    results
}

###
# Test Predictor 
###

head(predict("The guy in front of me just bought a pound of bacon, a bouquet, and a case of"))

head(predict("You're the reason why I smile everyday. Can you follow me please? It would mean the"))

head(predict("Hey sunshine, can you follow me and make me the"))

head(predict("Very early observations on the Bills game: Offense still struggling but the"))

head(predict("Go on a romantic date at the"))

head(predict("Well I'm pretty sure my granny has some old bagpipes in her garage I'll dust them off and be on my"))

head(predict("Ohhhhh #PointBreak is on tomorrow. Love that film and haven't seen it in quite some"))

head(predict("After the ice bucket challenge Louis will push his long wet hair out of his eyes with his little"))

head(predict("Be grateful for the good times and keep the faith during the"))

head(predict("If this isn't the cutest thing you've ever seen, then you must be"))



# print(clean.lines)

