# This file filters dataframes by:
#         1. test-site
#         2. species classification
#         3. min. and max date

#Calling should look like: ???


####[filter.all.data]##############################################################################
# This function takes in (a dataframe, a test-ste, a species classification, minimum and maximum  #
# for dates) as parameters.  Then it filters the dataframe by test-site.  Next that dataframe is  #
# filtered by filtered by species classification.  After that, the dataframe is filtered by the   #
# time-slice in-between the min. date and max. date.  Next that dataframe has all unnessecary     #
# columns removed.  Finally that dateframe is returned.                                           #
###################################################################################################
filter.all.data <- function(df, sources, classes, date.min, date.max, blur=NULL, species="all") {
  
  # Filter by site location (e.g. T1, T2, and/or T3)
  filtered <- df[df$source %in% sources,]
   
  # Filter by species classification
  filtered <- filtered[filtered$class %in% classes,]
  
  # TODO: work with bluring
  
  # Get appropriate data time slice
  filtered <- filtered[filtered$date >= date.min,]
  filtered <- filtered[filtered$date <= date.max,]
  
  # Remove all columns from the dataframe except the columns for requested species
  if (grepl(species, "all")) {
    filtered.date <- NULL
    filtered.source <- NULL
  } else {
    filtered <- filtered[colnames(filtered) %in% species] 
  }
 
  return(filtered)
}
