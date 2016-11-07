library(animation)
library(ggplot2)
library(RColorBrewer)

render.ciliates.plot <- function(ciliates.df, sources, date.min, date.max) {
  
  filtered <- ciliates.df[ciliates.df$site %in% sources,]
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

# render.ciliates.animation <- function(ciliates.df, sources, date.min, date.max) {
#   
#   filtered <- ciliates.df[ciliates.df$site %in% sources,]
#   filtered <- filtered[filtered$Date >= date.min,]
#   filtered <- filtered[filtered$Date <= date.max,]
#   filtered$month <- NULL
#   filtered$year <- NULL
#   filtered$site <- NULL
#   filtered$X <- NULL
#   filtered$TotalCellsPerLiter <- NULL
#   filtered$Date <- NULL
#   
#   filtered <- colSums(filtered) / nrow(filtered)
#   filtered <- cbind(read.table(text=names(filtered)), filtered)
#   names(filtered) <- c("species", "value")
#   
#   palette <- brewer.pal(ncol(filtered), "Set3")
#   
#   animate <- function() {
#     for (i in 1:nrow(filtered)) {
#       sample <- filtered[i,]
#       
#       #create scatterplot for current date
#       plot(x=sample$value, y=sample$species, col=palate[as.character(sample$species)], cex=1, pch=19, xlim=c(0, 5000), ylim=c(0,11))
#       #legend(x="bottomright", as.character(levels(sample$species)), col=palate[as.character(sample$species)], pch=19, cex=0.75)
#     }
#   }
#   ani.options(interval=0.067, ani.width=640, ani.height=480)
#   saveVideo(expr=animate(), video.name = "ciliates.mp4", ffmpeg = "C:\\Program Files\\ffmpeg\\bin\\ffmpeg.exe")
#   
#   # filtered <- colSums(filtered) / nrow(filtered)
#   # filtered <- cbind(read.table(text=names(filtered)), filtered)
#   # names(filtered) <- c("species", "value")
#   
#   return(ggplot(filtered, aes(x=value, y=species)) + geom_point())
# }