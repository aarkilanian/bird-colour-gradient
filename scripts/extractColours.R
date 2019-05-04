require(magick)
require(imager)

example <- load.image("/home/alex/Pictures/birdImages/Actitis-macularius.jpeg")
RGBtoHSL(example)

##### Remove background #####

# For each image in the birdImages directory, load the image with the magick package and make the white background transparent
birds <- list.files("/home/alex/Pictures/birdImages/")

h.vals <- list()
s.vals <- list()
l.vals <- list()

for (i in 1:length(birds)){
  # Read, remove the background and rewrite the image to disk with magick
  filepath <- paste("/home/alex/Pictures/birdImages/", birds[i], sep = "")
  bird.jpeg <- image_read(filepath)
  bird.jpeg <- image_transparent(bird.jpeg, "white")
  image_write(bird.jpeg, paste("/home/alex/Pictures/birdImagesTrans/", birds[i], sep = ""))
  
  # Read with imager and convert to HSL colour space
  filepath <- paste("/home/alex/Pictures/birdImagesTrans/", birds[i], sep = ""))
  bird.jpeg <- load.image(filepath)
  bird.hsl <- RGBtoHSL(bird.jpeg)
  
  # Fill H, S, L values into lists
  h.vals[[i]] <- bird.hsl[,,1]
  s.vals[[i]] <- bird.hsl[,,2]
  l.vals[[i]] <- bird.hsl[,,3]
  
  # Name these matrices in the list based on the species
  genus <- unlist(strsplit(birds[i], split = '-'))[1]
  species <- unlist(strsplit(unlist(strsplit(birds[i], split = '-'))[2], split = ".jpeg"))
  names(h.vals)[i] <- paste(genus, "-", species)
  names(s.vals)[i] <- paste(genus, "-", species)
  names(l.vals)[i] <- paste(genus, "-", species)
}

example.transparent <- image_transparent(example, "white")
image_write(image, "/home/alex/Pictures/birdImagesTrans/image.jpeg")

load.image