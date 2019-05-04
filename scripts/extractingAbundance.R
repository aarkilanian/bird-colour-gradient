##### Extracting bird abundance data from July 2018 across national parks #####

require(rinat)
locations <- read.csv("data/location.csv")

final <- as.data.frame(cbind("Japser", get_inat_obs(taxon_id = 3, geo = TRUE, year = 2018, month = 7, bounds = c(locations$min.lat[7]-0.2,
                                                                                   locations$min.lng[7]-0.2,
                                                                                   locations$max.lat[7]+0.2,
                                                                                   locations$max.lng[7]+0.2))[,1]))

for (i in 8:17){
  rbind(final,
        cbind(
          locations$parks[i],
          get_inat_obs(taxon_id = 3, geo = TRUE, year = 2018, month = 7, bounds = c(locations$min.lat[i]-0.2,
                                                                                    locations$min.lng[i]-0.2,
                                                                                    locations$max.lat[i]+0.2,
                                                                                    locations$max.lng[i]+0.2))[,1]
        ))
}

## Running through individual data frames

final <- as.data.frame(rbind(
  cbind(as.character(locations$parks[7]), jasper$scientific_name),
  cbind(as.character(locations$parks[8]), banff$scientific_name),
  cbind(as.character(locations$parks[9]), waterton.lakes$scientific_name),
  cbind(as.character(locations$parks[10]), north.cascades$scientific_name),
  cbind(as.character(locations$parks[11]), mont.rainier$scientific_name),
  cbind(as.character(locations$parks[12]), yellowstone$scientific_name),
  cbind(as.character(locations$parks[13]), grand.bassin$scientific_name),
  cbind(as.character(locations$parks[14]), zion$scientific_name),
  cbind(as.character(locations$parks[15]), joshua.tree$scientific_name),
  cbind(as.character(locations$parks[16]), saguaro$scientific_name),
  cbind(as.character(locations$parks[17]), big.bend$scientific_name)
))

## Summarize counts
final <- count(final, V1:V2)

final <- as.data.frame(cbind(str_split_fixed(final$`V1:V2`, ":", n = 2), count = as.numeric(final$n)))
names(final) = c("site", "species", "count")

## Calculating relative abundances

rel.abnundance <- final %>%
  group_by(site) %>%
  summarise(site.abundance = n())

final <- final %>%
  left_join(rel.abnundance)

final$count <- as.numeric(final$count)

final$rel.abundance <- final$count / final$site.abundance

## Remove family names that are alone

final$keep <- logical(length = length(final[,1]))
for (i in 1:length(final[,1])){
  final$keep[i] <- ifelse(length(unlist(str_split(final$species[i], " "))) < 2, FALSE, TRUE)
}

final <- subset(final, final$keep)

write.csv("data/abundances.csv")