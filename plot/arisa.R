

render.arisa.plot <- function(arisa.df, sources, date.min, date.max) {
  filtered <- arisa.df[arisa.df$source %in% sources,]
  filtered <- filtered[filtered$Date >= date.min,]
  filtered <- filtered[filtered$Date <= date.max,]
  filtered$X <- NULL
  filtered$source <- NULL
  filtered$Date <- NULL
  
  
  # Render a barplot
  return(barplot(colSums(filtered) / nrow(filtered),
          main=paste("Relative abundance of bacteria from", paste(sources, collapse=","), "from", date.min, "to", date.max),
          ylab="Relative Abundance",
          xlab="Species"))
}