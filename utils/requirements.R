list_of_packages = c(
    'dplyr',
    'pander',
    'ggplot2',
    'RWekajars',
    'qdapDictionaries',
    'qdapRegex',
    'qdapTools',
    'RColorBrewer',
    'qdap',
    'NLP',
    'tm',
    'SnowballC',
    'slam',
    'RWeka',
    'rJava',
    'wordcloud',
    'stringr',
    'DT',
    'stringi',
    'ngram',
    'foreach',
    'doParallel',
    'quanteda'
)

installed_packages = installed.packages()
for (package in list_of_packages){
    if(!(package %in% rownames(installed_packages))){
        install.packages(package)
    }
    library(package, character.only=TRUE)
}

cpu_core_qty = parallel::detectCores()
registerDoParallel(makeCluster(cpu_core_qty))
set.seed(112123)
