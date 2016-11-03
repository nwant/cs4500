get.arisa <- function(config) {
 arisa <- read.csv(config[["arisa.fp"]], header = TRUE)
 arisa$source <- substr(arisa$X, 1, 3) 
 arisa$date <- as.Date(substr(arisa$X, 5, 100), "%m_%d_%y")
 
 return(arisa)
}
