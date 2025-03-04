#' Read HTS2 results from a directory
#'
#' This function reads CSV files matching the provided glob pattern from the
#' specified directory and its subdirectories, and returns a data frame
#' containing the combined results.
#'
#' @param path The directory path to search for CSV files.
#' @param glob A glob pattern to match the CSV file names.
#' @return A data frame containing the combined HTS2 results.
read_hts2_results <- function(path, glob) {
  dir_ls(
    path = path,
    recurse = TRUE,
    glob = glob
  ) |>
    map_df(read_csv)
}

#' Plot bar chart of gene data
#'
#' Creates a bar plot for genes, excluding "Non-hit" category and showing only sgRNAs
#' that have correct nuclear segmentation.
#'
#' @param df Data frame containing the gene data.
#' @param x_variable The variable to plot on the x-axis.
#' @param plot_title Optional title for the plot (default: "").
#' @return A ggplot object with the bar chart.
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

#' Plot replicates comparison
#'
#' Creates a scatter plot comparing replicates with a linear regression line,
#' excluding "killer" control sgRNA.
#'
#' @param df Data frame containing the replicate data.
#' @param x_variable The variable for replicate 1 (x-axis).
#' @param y_variable The variable for replicate 2 (y-axis).
#' @param plot_title Optional title for the plot (default: "").
#' @return A ggplot object comparing replicates.
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

#' Create scatter plot with categorical coloring
#'
#' Creates a detailed scatter plot with custom color palette for different categories,
#' labeled points, and a linear regression line.
#'
#' @param df Data frame containing the point data.
#' @param x_variable The variable for the x-axis.
#' @param y_variable The variable for the y-axis.
#' @param x_lab Label for the x-axis.
#' @param y_lab Label for the y-axis.
#' @param plot_title Optional title for the plot (default: "").
#' @param axis_title_rel Relative size of axis titles (default: 1.5).
#' @param axis_text_rel Relative size of axis text (default: 1.5).
#' @param title_rel Relative size of plot title (default: 1.5).
#' @return A ggplot object with the scatter plot.
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
