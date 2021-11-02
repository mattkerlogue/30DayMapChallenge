# #30DayMapChallenge 2021
# Day 1: Points

library(tidyverse)
library(patchwork)

tree_data <- readr::read_csv("2021/data/Borough_tree_list_2021July.csv")
southwark_boundary <- readr::read_rds("2021/data/southwark_boundary.rds")

southwark_trees <- tree_data |>
  dplyr::filter(borough == "Southwark") |>
  dplyr::mutate(
    age_group = factor(age_group,
                       levels = c("Young (0-15)", "Early mature (16-30",
                                  "Mature (31-80)", "Over mature (81-150)",
                                  "Veteran (over 150)"),
                       ordered = TRUE)
  )

southwark_trees_sf <- southwark_trees |>
  tidyr::drop_na(age_group) |>
  dplyr::arrange(age_group) |>
  sf::st_as_sf(coords = c("longitude", "latitude"), crs = sf::st_crs(4326))

overall_map <- ggplot(southwark_trees_sf) +
  geom_sf(data = southwark_boundary, fill = "grey90", colour = "grey60") +
  geom_sf(aes(fill = age_group), 
          shape = 21, colour = "#006D2C", size = 2.5, stroke = 0.1,
          show.legend = FALSE) +
  scale_fill_brewer(palette = "Greens",
                    guide = guide_legend(title = "Age of tree")) +
  facet_wrap(~"All trees", nrow = 1) +
  mattR::theme_lpsdgeog() +
  theme(
    plot.background = element_rect(fill = "#ffffff", colour = "#31A354", size = 2)
  )

facet_map <- ggplot(southwark_trees_sf) +
  geom_sf(data = southwark_boundary, fill = "grey90", colour = "grey60") +
  geom_sf(aes(fill = age_group), 
          shape = 21, colour = "#006D2C", size = 1.5, stroke = 0.1,
          show.legend = FALSE) +
  scale_fill_brewer(palette = "Greens",
                    guide = guide_legend(title = "Age of tree")) +
  facet_wrap(~age_group, nrow = 1) +
  mattR::theme_lpsdgeog() +
  theme(
    axis.text = element_blank(),
    plot.background = element_rect(fill = "#ffffff", colour = "#31A354", size = 2)
  )

out_map <- overall_map + 
  facet_map +
  plot_annotation(
    title = "TREES IN SOUTHWARK",
    subtitle = "Publicly owned trees by age of tree",
    caption = paste(
      "Data: Local Authorty Maintained Trees, Greater London Authority, 2021",
      "Visualisation: @mattkerlogue, github.com/mattkerlogue",
      sep = "\n"),
    theme = mattR::theme_lpsdgeog(subtitle = TRUE) +
      theme(
        text = element_text(colour = "#ffffff"),
        plot.title = element_text(size = 16),
        plot.subtitle = element_text(size = 12),
        plot.background = element_rect(fill = "#31A354", colour = NA)
      )
  )

ggsave("2021/2021-11-01_southwark-trees.png", out_map,
       width = 1089*3, height = 526*3, units = "px", dpi = 300)
