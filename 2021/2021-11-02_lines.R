# #30DayMapChallenge 2021
# Day 2: Lines

countries <- rnaturalearth::ne_countries(returnclass = "sf")

places <- rnaturalearth::ne_download(
  scale = "large", type = "populated_places", category = "cultural", 
  returnclass = "sf")

glasgow <- places |>
  dplyr::filter(NAME == "Glasgow", SOV_A3 == "GBR")

capitals <- places |>
  dplyr::filter(FEATURECLA == "Admin-0 capital") |>
  dplyr::mutate(
    glasgow_geo = glasgow$geometry,
    flight = sf::st_sfc(map2(geometry, glasgow_geo, ~sf::st_cast(sf::st_union(.x, .y), "LINESTRING")), crs = sf::st_crs(4326)),
    distance = units::set_units(
      sf::st_distance(geometry, glasgow_geo, by_element = TRUE),
      "km"
    )
  )

ggplot(capitals) +
  geom_sf(data = countries, fill = NA, colour = "grey80", size = 0.25) +
  geom_sf(aes(geometry = flight), colour = "blue") +
  geom_sf(data = glasgow, colour = "red") +
  theme_void() +
  coord_sf()
