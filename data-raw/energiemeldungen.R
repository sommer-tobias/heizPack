## code to prepare `DATASET` dataset goes here

energiemeldungen <- read_excel("inst/extdata/report_2024-01-03.xlsx")

energiemeldungen <- energiemeldungen %>% mutate(nachweis = NA)
energiemeldungen$nachweis[is.na(energiemeldungen$Standardlösung)] <- energiemeldungen$`Nachweis Weg`[is.na(energiemeldungen$Standardlösung)]
energiemeldungen$nachweis[energiemeldungen$`Nachweis Weg` %in% 'Standardlösung'] <- energiemeldungen$Standardlösung[energiemeldungen$`Nachweis Weg` %in% 'Standardlösung']

energiemeldungen <- energiemeldungen %>% mutate(jahr = substr(`Datum Meldung`, 1, 4))
energiemeldungen <- energiemeldungen %>% select(`Datum Meldung`, `Neues Heizsystem`, `Altes Heizsystem`)



usethis::use_data(energiemeldungen, overwrite = TRUE)
