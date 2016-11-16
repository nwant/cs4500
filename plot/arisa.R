# This file renders a barplot from the arisa CSV file using the arisa dataframe

# Calling should look like: ???

####[render.arisa.plot]####################################################################
# This function takes in (the arisa dataframe, test-site, minimum and maximum dates) as   #
# parameters.  Then it takes the arisa dataframe and filters it into a filtered dataframe #
# by test-site.  Next that dataframe is filtered again by min. and max. date.  After that,#
# all unnecessary values are removed.  Finally a barplot is returned based of the filtered #
# dataframe, and is given a title, y-axis label and x-axis label.                         #
###########################################################################################
render.arisa.plot <- function(arisa.df, sources, date.min, date.max) {
  
  # Filters arisa.df by test-site
  filtered <- arisa.df[arisa.df$source %in% sources,]
  
  # Filters arisa.df by min. date
  filtered <- filtered[filtered$date >= date.min,]
  
  # Filters arisa.df by max. date
  filtered <- filtered[filtered$date <= date.max,]
  
  # Clears out all unnecessary values
  filtered$X <- NULL
  filtered$source <- NULL
  filtered$date <- NULL
  
  
  # Render a barplot
  return(barplot(colSums(filtered) / nrow(filtered),
          main=paste("Relative abundance of bacteria from", paste(sources, collapse=","), "from", date.min, "to", date.max),
          ylab="Relative Abundance",
          xlab="Species"))
}
