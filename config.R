get.config <- function() {
    return(c(
        R.repos = "http://cran.us.r-project.org",
        arisa.fp = "./source/ARISA.CSV",
        ciliates.1.fp = "./source/CILIATES_1.CSV",
        ciliates.2.fp = "./source/CILIATES_2.CSV"
    ))
}
