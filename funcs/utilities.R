read_hts2_results <- function(path, glob) {
  dir_ls(
    path = path,
    recurse = TRUE,
    glob = glob
  ) |>
    map_df(read_csv)
}

plot_bars <- function(df, x_variable, plot_title = "") {
  df |>
    filter(category != "Non-hit" & nuclear_segmentation == "correct") |>
    ggplot(aes(
      x = {{ x_variable }},
      y = gene_symbol,
      fill = category
    )) +
    geom_bar(stat = "identity") +
    scale_fill_discrete(name = "Category") +
    theme(legend.position = "none") +
    scale_y_discrete(limits = rev) +
    labs(
      x = "Z-Score",
      y = "Gene Symbol",
      title = plot_title
    )
}

plot_replicates <- function(df, x_variable, y_variable, plot_title = "") {
  df |>
    filter(control != "killer") |>
    ggplot(
      aes(
        x = {{ x_variable }},
        y = {{ y_variable }},
        color = control,
      )
    ) +
    geom_point(shape = 21) +
    geom_smooth(
      method = "lm",
      color = "grey50"
    ) +
    scale_color_discrete(name = "Treatment") +
    facet_wrap(vars(cell_line)) +
    xlab("Z-score Replicate 1") +
    ylab("Z-score Replicate 2") +
    ggtitle(plot_title)
}

plot_points <- function(
  df,
  x_variable,
  y_variable,
  x_lab,
  y_lab,
  plot_title = "",
  axis_title_rel = 1.5,
  axis_text_rel = 1.5,
  title_rel = 1.5
) {
  custom_palette <- c(
    "Non-hit" = "black",
    "Other" = "#E26A62",
    "Transcription" = "#63A832",
    "Chromatin structure" = "#AE8B2E",
    "Replication" = "#56B488",
    "Nucleolus" = "#4EA5D4",
    "Nuclear pore" = "#8F73F7",
    "Kinetochore" = "#E459CB"
  )

  df |>
    filter(control == "sample") |>
    mutate(
      marker = ifelse(
        label == "yes",
        gene_symbol,
        ""
      ),
      alpha_dot = ifelse(
        category == "Non-hit",
        0.5,
        1
      )
    ) |>
    ggplot(
      aes(
        x = {{ x_variable }},
        y = {{ y_variable }},
        color = category,
        label = marker,
        alpha = alpha_dot
      )
    ) +
    geom_text_repel(
      box.padding = 0.5,
      max.overlaps = Inf,
    ) +
    geom_point() +
    geom_smooth(
      method = "lm",
      color = "grey50"
    ) +
    scale_color_manual(values = custom_palette) +
    theme(
      legend.position = "none",
      axis.title = element_text(size = rel(axis_title_rel)),
      axis.text = element_text(size = rel(axis_text_rel)),
      plot.title = element_text(size = rel(title_rel))
    ) +
    xlab(x_lab) +
    ylab(y_lab) +
    ggtitle(plot_title)
}
