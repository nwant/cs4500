filter <- function(df, species, sources, date.min, date.max) {
  filtered <- df[colnmes(df) %in% species] 
  filtered <- filtered[filtered$source %in% sources,]
  filtered <- filtered[filtered$date >= date.min,]
  filtered <- filtered[filtered$date <= date.max,]
}