###script to do a 3D scatterplot 

####library
library(plot3D)
library(dplyr)

#extraction from data documents in github
site_means <- read_csv("data/site.means.csv")


#variables identification from means HSL values
h<- site_means$h
s<- site_means$s
l<- site_means$l
parks_names<-site_means$site

scatter3D(h, s, l, bty = "g", 
          theta = 40, phi = 20,
          xlim=c(0,390), ylim=c(0,1), zlim=c(0,1.6),
          type="h", col="black",
          pch=20, cex=(3),
          xlab="H", ylab="S", zlab="L")

text3D(h,s,l,labels = parks_names, srt=90,
       add = TRUE, colkey = TRUE)





         