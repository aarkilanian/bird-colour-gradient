require(rvest)

abundance <- read.csv("data/abundances.csv")
abundance$species <- as.character(abundance$species)

# For each row in the bird occurence dataframe, search the audubon field guide for the scientific name and download the associated jpeg image file into a directory with the name of the bird
birds <- unique(abundance$species)

for (i in 82:length(abundance[,1])){
  
  # Get url corresponding to search for specific bird species
  genus <- strsplit(birds[i], split = " ")[[1]][1]
  species <- strsplit(birds[i], split = " ")[[1]][2]
  url <- paste("https://www.audubon.org/bird-guide?search_api_views_fulltext=",
               genus,
               "%20",
               species,
               "&field_bird_family_tid=All&field_bird_region_tid=All",
               sep = "")
  
  # Point to the image on the page
  img <- read_html(url) %>%
    html_node(xpath = '//img') %>%
    html_attr('src')
  
  # Download image into a local directory
  download.file(img, paste("/home/alex/Pictures/birdImages/", genus, "-", species, ".jpeg", sep = ""))
}
