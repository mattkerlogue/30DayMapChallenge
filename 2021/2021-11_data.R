# #30DayMapChallenge 2021
# Data file sources/downloads

# upper-tier boundaries
utla_json <- "https://opendata.arcgis.com/datasets/244b257482da4778995cf11ff99e9997_0.geojson"
utla_boundaries <- sf::st_read(utla_json)
write_rds(utla_boundaries, file.path("2021", "data", "utla_boundaries.rds"))

# southwark boundary
southwark_boundary <- utla_boundaries |>
  dplyr::filter(CTYUA21NM == "Southwark")

write_rds(southwark_boundary, file.path("2021", "data", "southwark_boundary.rds"))

# Tree data - day 1
tree_data_url <- "https://data.london.gov.uk/download/local-authority-maintained-trees/a2a0ae91-cdf5-4bcd-8b23-2a40f1d854e9/Borough_tree_list_2021July.csv"

download.file(tree_data_url, file.path("2021", "data", basename(tree_data_url)))