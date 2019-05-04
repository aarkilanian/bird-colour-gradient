require(magick)
require(imager)

##### Remove background #####

# For each image in the birdImages directory, load the image with the magick package and make the white background transparent
birds <- list.files("/home/alex/Pictures/birdImages/")

h.vals <- list()
s.vals <- list()
l.vals <- list()
background <- list()

for (i in 1:length(birds)){
  # Read, remove the background and rewrite the image to disk with magick
  filepath <- paste("/home/alex/Pictures/birdImages/", birds[i], sep = "")
  bird.jpeg <- image_read(filepath)
  bird.png <- image_convert(bird.jpeg, format = "png")
  bird.png <- image_transparent(bird.png, "#FFFFFF", fuzz = 10)
  image_write(bird.png, paste("/home/alex/Pictures/birdImagesTrans/", birds[i], ".png", sep = ""))
  
  # Save the transperency layer to be used during analysis
  bird.png <- load.image(paste("/home/alex/Pictures/birdImagesTrans/", birds[i], ".png", sep = ""))
  bird.transparent <- bird.png[,,4]
  
  # Read with imager and convert to HSL colour space
  filepath <- paste("/home/alex/Pictures/birdImages/", birds[i], sep = "")
  bird.jpeg <- load.image(filepath)
  bird.hsl <- RGBtoHSL(bird.jpeg)
  
  # Fill H, S, L values into lists
  h.vals[[i]] <- bird.hsl[,,1]
  s.vals[[i]] <- bird.hsl[,,2]
  l.vals[[i]] <- bird.hsl[,,3]
  background[[i]] <- bird.transparent
  
  # Name these matrices in the list based on the species
  genus <- unlist(strsplit(birds[i], split = '-'))[1]
  species <- unlist(strsplit(unlist(strsplit(birds[i], split = '-'))[2], split = ".jpeg"))
  names(h.vals)[i] <- paste(genus, "-", species, sep = "")
  names(s.vals)[i] <- paste(genus, "-", species, sep = "")
  names(l.vals)[i] <- paste(genus, "-", species, sep = "")
  names(background) <- paste(genus, "-", species, sep = "")
  
  # Replace values representing backgournd with NA in H, S, L matrices with NA values
  h.vals[[i]][background[[i]] == FALSE] <- NA
  s.vals[[i]][background[[i]] == FALSE] <- NA
  l.vals[[i]][background[[i]] == FALSE] <- NA
}