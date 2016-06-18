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

df_1_grams = get_ngrams(1)
df_2_grams = get_ngrams(2)






# print(clean.lines)

