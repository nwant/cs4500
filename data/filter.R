filter.all.data <- function(df, species, sources, date.min, date.max, blur) {
  # filter by site location (e.g. T1, T2, and/or T3)
  filtered <- df[df$source %in% sources,]
  
  # TODO: work with bluring
  
  # get appropriate data time slice
  filtered <- filtered[filtered$date >= date.min,]
  filtered <- filtered[filtered$date <= date.max,]
  
  # remove all columns from the dataframe except the columns for requested species
  filtered <- filtered[colnames(filtered) %in% species] 
 
  return(filtered)
}