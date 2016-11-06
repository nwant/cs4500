render.arisa.plot <- function(ciliates.df, sources, date.min, date.max) {
  filtered <- arisa[arisa$source %in% sources,]
  filtered <- filtered[filtered$date >= date.min,]
  filtered <- filtered[filtered$date <= date.max,]
  filtered$X <- NULL
  filtered$source <- NULL
  filtered$date <- NULL
  
  
  # Render a barplot
  return(barplot(colSums(filtered) / nrow(filtered),
          main=paste("Relative abundance of bacteria from", paste(sources, collapse=","), "from", date.min, "to", date.max),
          ylab="Relative Abundance",
          xlab="Species"))
}