library(ggplot2)

render.ciliates.plot <- function(ciliates.df, sources, date.min, date.max) {
  
  filtered <- ciliates.1[ciliates.df$site %in% sources,]
  filtered <- filtered[filtered$Date >= date.min,]
  filtered <- filtered[filtered$Date <= date.max,]
  filtered$month <- NULL
  filtered$year <- NULL
  filtered$site <- NULL
  filtered$Date <- NULL
  filtered$X <- NULL
  filtered$TotalCellsPerLiter <- NULL
  
  filtered <- colSums(filtered) / nrow(filtered)
  filtered <- cbind(read.table(text=names(filtered)), filtered)
  names(filtered) <- c("species", "value")
  
  return(ggplot(filtered, aes(x=value, y=species)) + geom_point())
}