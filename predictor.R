source('utils/requirements.R')
source('utils/data.R')
prepare_data()
source('utils/ngrams.R')
# prepare_sample_files()

if (!is_ngrams_ready(ngrams_n)){
    
    print("Load Data")
    timer = system.time({
        # lines = get_combined_data()    
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
    selected_df = filter(ngrams_df, grepl(search_pattern, terms)) %>% 
        select(starts_with("terms")) %>%
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

# Question 1
prediction = predict("I'll be there for you, I'd live and I'd")
matched = prediction[prediction %in% c('sleep', 'die', 'eat', 'give')]
print(matched)


# Question 2
prediction = predict("Guy at my table's wife got up to go to the bathroom and I asked about dessert and he started telling me about his")
matched = prediction[prediction %in% c('spiritual', 'financial', 'marital', 'horticultural')]
print(matched)


# Question 3
prediction = predict("I'd give anything to see arctic monkeys this")
matched = prediction[prediction %in% c('morning', 'decade', 'month', 'weekend')]
print(matched)


# Question 4
prediction = predict("Talking to your mom has the same effect as a hug and helps reduce your")
matched = prediction[prediction %in% c('sleepiness', 'hunger', 'stress', 'happiness')]
print(matched)


# Question 5
prediction = predict("When you were in Holland you were like 1 inch away from me but you hadn't time to take a")
matched = prediction[prediction %in% c('minute', 'look', 'picture', 'walk')]
print(matched)


# Question 6
prediction = predict("I'd just like all of these questions answered, a presentation of evidence, and a jury to settle the")
matched = prediction[prediction %in% c('matter', 'account', 'incident', 'case')]
print(matched)


# Question 7
prediction = predict("I can't even hold an uneven number of bags of groceries in each")
matched = prediction[prediction %in% c('toe', 'hand', 'arm', 'finger')]
print(matched)


# Question 8
prediction = predict("Every inch of you is perfect from the bottom to the")
matched = prediction[prediction %in% c('center', 'top', 'middle', 'side')]
print(matched)


# Question 9
prediction = predict("I’m thankful my childhood was filled with imagination and bruises from playing")
matched = prediction[prediction %in% c('outside', 'inside', 'daily', 'weekly')]
print(matched)


# Question 10
prediction = predict("I like how the same people are in almost all of Adam Sandler's")
matched = prediction[prediction %in% c('pictures', 'novels', 'movies', 'stories')]
print(matched)


