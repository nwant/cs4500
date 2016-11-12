filter.all.data <- function(df, sources, classes, date.min, date.max, blur=NULL, species="all") {
  # filter by site location (e.g. T1, T2, and/or T3)
  filtered <- df[df$source %in% sources,]
   
  # filter by species classification
  filtered <- filtered[filtered$class %in% classes,]
  
  # TODO: work with bluring
  
  # get appropriate data time slice
  filtered <- filtered[filtered$date >= date.min,]
  filtered <- filtered[filtered$date <= date.max,]
  
  # remove all columns from the dataframe except the columns for requested species
  if (grepl(species, "all")) {
    filtered.date <- NULL
    filtered.source <- NULL
  } else {
    filtered <- filtered[colnames(filtered) %in% species] 
  }
 
  return(filtered)
}