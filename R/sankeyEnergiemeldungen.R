#' Create Sankey Plots based on dataset Energiemeldungen
#'
#' @param ejahr Jahr der Auswertung (integer zwischen 2019 und 2023)
#'
#' @return Grafik der Auswertung
#' @export
#' @autoglobal
#' @examples
#' \dontrun{
#' sankeyEnergiemeldungen(2019)
#' }
sankeyEnergiemeldungen <- function(ejahr) {
  # ejahr <- as.character(2023)
  df <- energiemeldungen %>% filter(`Datum Meldung` >= paste0(ejahr, "-01-01") & `Datum Meldung` <= paste0(ejahr, "-12-31"))
  df <- df %>% rename(alt = `Altes Heizsystem`, neu = `Neues Heizsystem`)
  df <- df %>% make_long(alt, neu)
  # count the occureneces in the flow
  flowNumbers <- df %>%
    group_by(x, node, next_x, next_node) %>%
    tally() %>%
    filter(!is.na(next_x)) %>%
    ungroup()

  # count the changes fossil to fossil
  oilOil <- flowNumbers %>% filter((node %in% "\u00D6lheizung") & (next_node %in% "\u00D6lheizung"))
  gasGas <- flowNumbers %>% filter((node %in% "Gasheizung") & (next_node %in% "Gasheizung"))
  oilGas <- flowNumbers %>% filter((node %in% "\u00D6lheizung") & (next_node %in% "Gasheizung"))
  gasOil <- flowNumbers %>% filter((node %in% "Gasheizung") & (next_node %in% "\u00D6lheizung"))
  fossilFossil <- oilOil %>%
    full_join(gasGas) %>%
    full_join(oilGas) %>%
    full_join(gasOil)
  fossilFossilNumber <- fossilFossil %>%
    summarise(summe = sum(n)) %>%
    pull(summe)
  totalNumber <- flowNumbers %>%
    ungroup() %>%
    summarise(summe = sum(n)) %>%
    pull(summe)

  # count changes to fossil
  toFossil <- flowNumbers %>% filter(next_node %in% c("\u00D6lheizung", "Gasheizung"))
  toFossil <- toFossil %>%
    summarize(n = sum(n)) %>%
    pull(n)
  anteilToFossil <- toFossil / totalNumber

  anteilFossilFossil <- fossilFossilNumber / totalNumber
  # count fossil to fossil
  # count the occurences in the nodes
  nodeNumbers <- df %>%
    group_by(node, x) %>%
    tally()
  fossilOriginNumber <- nodeNumbers %>%
    filter(node %in% "\u00D6lheizung" & x %in% "alt") %>%
    pull(n)
  # anteilFossilFossil <- fossilFossilNumber/fossilOriginNumber

  # df2 <- merge(df, dagg, by.x = 'node', by.y = 'node', all.x = TRUE)

  df1 <- df %>% full_join(nodeNumbers)

  p <- ggplot(df1, aes(
    x = x,
    next_x = next_x,
    node = node,
    next_node = next_node,
    fill = factor(node),
    label = paste0(node, " n=", n)
  ))

  p <- p +
    geom_sankey(
      flow.alpha = 0.5,
      node.color = "black",
      show.legend = FALSE
    )

  # get geometrical details of flows
  flowInfo <- layer_data(p) %>%
    select(xmax, flow_start_ymax, flow_start_ymin) %>%
    distinct()
  # sort
  flowInfo <- flowInfo[with(flowInfo, order(xmax, flow_start_ymax)), ]
  # don't understand this
  rownames(flowInfo) <- NULL
  # put flow info and flow labels together
  flowInfo <- cbind(as.data.frame(flowInfo), as.data.frame(flowNumbers))

  # put the flow numbers into the graph
  for (i in 1:nrow(flowInfo)) {
    p <- p + annotate("text",
      x = flowInfo$xmax[i],
      y = (flowInfo$flow_start_ymin[i] + flowInfo$flow_start_ymax[i]) / 2,
      label = sprintf("%d", flowInfo$n[i]), hjust = -1,
      size = 3
    )
  }

  p <- p + geom_sankey_label(size = 3, color = "black", fill = "white", hjust = 1)
  p <- p + theme_bw()
  p <- p + theme(legend.position = "none")
  p <- p + theme(
    axis.title = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )
  p <- p + scale_fill_viridis_d(option = "inferno")
  p <- p + labs(title = paste0("Heizungswechsel ", ejahr))

  # p <- p + labs(subtitle = paste0('Meldungen: ', totalNumber , ', alt = fossil: ', fossilOriginNumber ,  ', Wechsel fossil-fossil: ', fossilFossilNumber , ', \n d.h. ', round((1-anteilFossilFossil) * 100), '% ersetzen Heizung klimaneutral.'))
  p <- p + labs(subtitle = paste0("Meldungen: ", totalNumber, ", Wechsel zu fossil: ", toFossil, ", \n d.h. ", round((1 - anteilToFossil) * 100), "% ersetzen Heizung klimaneutral."))

  p <- p + labs(fill = "Nodes")

  # output <- list()
  # output$sankey <- p
  # output$anteilErneuerbar <- 1 - anteilToFossil
  # output$jahr <- ejahr
  # output$anzahlMeldungen <- totalNumber

  output <- p
  return(output)
}
