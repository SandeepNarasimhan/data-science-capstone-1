list_of_packages = c(
    'dplyr',
    'pander',
    'ggplot2'
)

installed_packages = installed.packages()
for (package in list_of_packages){
    if(!(package %in% rownames(installed_packages))){
        install.packages(package)
    }
    library(package, character.only=TRUE)
}
