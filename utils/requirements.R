list_of_packages = c(
    'plyr',
    'dplyr',
    'pander',
    'text2vec',
    'tokenizers',
    'ggplot2',
    'RWekajars',
    'qdapDictionaries',
    'qdapRegex',
    'qdapTools',
    'RColorBrewer',
    'qdap',
    'tm',
    'NLP',
    'openNLP',
    'SnowballC',
    'slam',
    'RWeka',
    'rJava',
    'wordcloud',
    'stringr',
    'DT',
    'stringi',
    'ngram',
    'quanteda',
    'foreach',
    'doParallel'
)

installed_packages = installed.packages()
for (package in list_of_packages){
    if(!(package %in% rownames(installed_packages))){
        install.packages(package)
    }
    library(package, character.only=TRUE)
}

max_cpu_qty = 4
detected_cpu_qty = parallel::detectCores()
cpu_core_qty = min(c(detected_cpu_qty, max_cpu_qty))
set.seed(112123)
