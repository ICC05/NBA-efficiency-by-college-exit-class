### TESINA INTERNA SCUOLA SUPERIORE SANT'ANNA ###
### IACOPO CARDOSI CARRARA ###
### MASTER OF SCIENCE IN ECONOMICS (QF) ###
### Creazione datset_Tesina ###


### IMPOSTAZIONI INIZIALI CODICE ###   


# Impostare la Working Directory
setwd("C:/Users/iacoc/OneDrive/Desktop/Tesina")

# Installa pacchetti necessari
install.packages("rvest")    # Per il web scraping
install.packages("httr")     # Per gestire richieste HTTP
install.packages("dplyr")    # Per manipolazione Dataset
install.packages("ggplot2")  # Per grafici
install.packages("fastDummies") # Per craere variabili Dummy
install.packages("tidyr") #  Per manipolazioni dataset

# Carica i pacchetti precedenti
library(rvest)
library(httr)
library(dplyr)
library(ggplot2)
library(fastDummies)
library(tidyr)

#####################################################################
#####################################################################
#####################################################################



### dataset_NBA_GPER (Intervallo: 1987/88 - 2023/24) ###

# Creazione dataset_NBA_GPER #

# Funzione per scaricare la tabella da un URL specifico
scarica_tabella <- function(url) {
  cat("Scaricando dati da:", url, "\n")  # Messaggio di debug
  pagina <- GET(url)
  
  # Estrarre il contenuto HTML della pagina
  pagina_html <- content(pagina, "text")
  
  # Fare il parsing dell'HTML per renderlo navigabile
  pagina_parsed <- read_html(pagina_html)
  
  # Estrarre la tabella specifica dalla pagina
  tabella <- pagina_parsed %>% html_node("table") %>% html_table(fill = TRUE)
  
  return(tabella)
}

# Lista degli URL dataset_NBA_PER
lista_url <- c(
  "https://stathead.com/tiny/sXIvQ",  # URL 1
  "https://stathead.com/tiny/929dP",  # URL 2
  "https://stathead.com/tiny/XJR5a",  # URL 3
  "https://stathead.com/tiny/qUsU0",  # URL 4
  "https://stathead.com/tiny/zYkFq",  # URL 5
  "https://stathead.com/tiny/gZiND",  # URL 6
  "https://stathead.com/tiny/1Tsok",  # URL 7
  "https://stathead.com/tiny/0PK1Y",  # URL 8
  "https://stathead.com/tiny/pQtnn",  # URL 9
  "https://stathead.com/tiny/AbwO6",  # URL 10
  "https://stathead.com/tiny/AbwO6",  # URL 11
  "https://stathead.com/tiny/69o2Z",  # URL 12
  "https://stathead.com/tiny/ct28Q",  # URL 13
  "https://stathead.com/tiny/4VpFD",  # URL 14
  "https://stathead.com/tiny/CQion",  # URL 15
  "https://stathead.com/tiny/71O5D",  # URL 16
  "https://stathead.com/tiny/57oVz",  # URL 17
  "https://stathead.com/tiny/8MIg5",  # URL 1
  "https://stathead.com/tiny/IPnOb",  # URL 19
  "https://stathead.com/tiny/Ubo4C",  # URL 20
  "https://stathead.com/tiny/8qpH8",  # URL 21
  "https://stathead.com/tiny/i0CJc",  # URL 22
  "https://stathead.com/tiny/dEmRV",  # URL 23
  "https://stathead.com/tiny/zGe6P",  # URL 24
  "https://stathead.com/tiny/Zc5LX",  # URL 25
  "https://stathead.com/tiny/kOQfV",  # URL 26
  "https://stathead.com/tiny/tQpbj",  # URL 27
  "https://stathead.com/tiny/MNyhf",  # URL 28
  "https://stathead.com/tiny/Bpqae",  # URL 29
  "https://stathead.com/tiny/QSHfY",  # URL 30
  "https://stathead.com/tiny/p2taa",  # URL 31
  "https://stathead.com/tiny/d2fHR",  # URL 32
  "https://stathead.com/tiny/Fj3JU",  # URL 33
  "https://stathead.com/tiny/skVPt",  # URL 34
  "https://stathead.com/tiny/hncNp",  # URL 35
  "https://stathead.com/tiny/voZl3",  # URL 36
  "https://stathead.com/tiny/I9IEw",  # URL 37
  "https://stathead.com/tiny/AM9O6",  # URL 38
  "https://stathead.com/tiny/A9dd2",  # URL 39
  "https://stathead.com/tiny/Gs0cw",  # URL 40
  "https://stathead.com/tiny/ZtOIe",  # URL 41
  "https://stathead.com/tiny/LECcl",  # URL 42
  "https://stathead.com/tiny/IUxrv",  # URL 43
  "https://stathead.com/tiny/a6Xet",  # URL 44
  "https://stathead.com/tiny/g9nFU",  # URL 45
  "https://stathead.com/tiny/QyuuZ",  # URL 46
  "https://stathead.com/tiny/soJIW",  # URL 47
  "https://stathead.com/tiny/owyPc",  # URL 48
  "https://stathead.com/tiny/UjM8l",  # URL 49
  "https://stathead.com/tiny/2qNmG",  # URL 50
  "https://stathead.com/tiny/4aGFv",  # URL 51
  "https://stathead.com/tiny/r1YrY",  # URL 52
  "https://stathead.com/tiny/8tWP6",  # URL 53
  "https://stathead.com/tiny/nGCi5",  # URL 54
  "https://stathead.com/tiny/COWel",  # URL 55
  "https://stathead.com/tiny/amlqm",  # URL 56
  "https://stathead.com/tiny/ICeea",  # URL 57
  "https://stathead.com/tiny/4lzUQ",  # URL 58
  "https://stathead.com/tiny/cfAOO",  # URL 59
  "https://stathead.com/tiny/wHZcJ",  # URL 60
  "https://stathead.com/tiny/bKCeR",  # URL 61
  "https://stathead.com/tiny/Cpzum",  # URL 62
  "https://stathead.com/tiny/ewqyX",  # URL 63 
  "https://stathead.com/tiny/yudti",  # URL 64
  "https://stathead.com/tiny/F1ojn",  # URL 65
  "https://stathead.com/tiny/4siLy",  # URL 66
  "https://stathead.com/tiny/2MTfH",  # URL 67
  "https://stathead.com/tiny/8RxtD",  # URL 68
  "https://stathead.com/tiny/G7dzP",  # URL 69
  "https://stathead.com/tiny/MEVtM"   # URL 70
  )


# Inizializza una lista per memorizzare tutte le tabelle
tutte_le_tabelle <- list()

# Ciclo per scaricare le tabelle dai 20 URL
for (url in lista_url) {
  # Scarica la tabella
  tabella <- scarica_tabella(url)
  
  # Aggiungi la tabella scaricata alla lista (se esiste)
  if (!is.null(tabella)) {
    tutte_le_tabelle[[length(tutte_le_tabelle) + 1]] <- tabella
  } else {
    cat("Nessuna tabella trovata per l'URL:", url, "\n")
  }
}

# Combina tutte le tabelle in un unico dataset (verticalmente)
dataset_NBA_GPER <- bind_rows(tutte_le_tabelle)


# MANIPOLAZIONE DATASET_NBA_GPER #


# Rinominare le colonne con i valori della prima riga
colnames(dataset_NBA_GPER) <- dataset_NBA_GPER[1, ]

# Determina gli indici delle righe da rimuovere: 1, 202, 403, ...
righe_da_rimuovere <- seq(1, nrow(dataset_NBA_GPER), by = 201)

# Rimuovi queste righe dal dataset
dataset_NBA_GPER <- dataset_NBA_GPER[-righe_da_rimuovere, ]

# Rimuovere la colonna 'Rk'
dataset_NBA_GPER <- dataset_NBA_GPER[, !names(dataset_NBA_GPER) %in% "Rk"]

# Trasformare la variabile 'season' prendendo solo il secondo anno
dataset_NBA_GPER$Season <- sub(".*-(\\d+)", "\\1", dataset_NBA_GPER$Season)

# Aggiungere "19" per anni > 80, "20" per anni <= 80
dataset_NBA_GPER$Season <- ifelse(as.numeric(dataset_NBA_GPER$Season) > 80,
                                 paste0("19", dataset_NBA_GPER$Season),
                                 paste0("20", dataset_NBA_GPER$Season))

# Trasformazione variabili
dataset_NBA_GPER$`Draft Year` <- as.integer(dataset_NBA_GPER$`Draft Year`)
dataset_NBA_GPER$Season <- as.integer(dataset_NBA_GPER$Season)
dataset_NBA_GPER$PER <- as.numeric(dataset_NBA_GPER$PER)
dataset_NBA_GPER$MP <- as.integer(dataset_NBA_GPER$MP)
dataset_NBA_GPER$G <- as.integer(dataset_NBA_GPER$G)

# Creazione della variabile 'year' come differenza tra 'Season' e 'Draft Year'
dataset_NBA_GPER$year <- dataset_NBA_GPER$Season - dataset_NBA_GPER$`Draft Year`

# Creare la nuova variabile GPER (PER*MP)
dataset_NBA_GPER$GPER <- dataset_NBA_GPER$PER * dataset_NBA_GPER$MP

# Filtrare il dataset per includere solo i giocatori con Draft Year <= 2014
dataset_NBA_GPER_filtered <- dataset_NBA_GPER %>%
  filter(`Draft Year` <= 2014)

# Calcola la media condizionata di GPER rispetto alla variabile year (All Players)
mean_GPER <- dataset_NBA_GPER_filtered %>%
  group_by(year) %>%
  summarize(mean_GPER = mean(GPER, na.rm = TRUE))

# Contare il numero di osservazioni per ciascun giocatore
player_counts <- dataset_NBA_GPER_filtered %>%
  group_by(Player) %>%
  summarize(n_obs = n(), 
            has_year_ge_10 = any(year >= 10))  # Verifica se ci sono osservazioni con year >= 10

# Filtrare i giocatori che hanno almeno una osservazione con year >= 10
players_with_year_ge_10 <- player_counts %>%
  filter(has_year_ge_10) %>%
  pull(Player)

# Calcolare la media condizionata di GPER (Players with year >= 10)
mean_GPER_with_year_ge_10 <- dataset_NBA_GPER_filtered %>%
  filter(Player %in% players_with_year_ge_10) %>%
  group_by(year) %>%
  summarize(mean_GPER = mean(GPER, na.rm = TRUE))

# Filtrare i giocatori che non hanno alcuna osservazione con Year >= 10
players_without_year_ge_10 <- setdiff(player_counts$Player, players_with_year_ge_10)

# Calcolare la media condizionata di GPER (Players without year >= 10)
mean_GPER_without_year_ge_10 <- dataset_NBA_GPER_filtered %>%
  filter(Player %in% players_without_year_ge_10) %>%
  group_by(year) %>%
  summarize(mean_GPER = mean(GPER, na.rm = TRUE))

# Creare un dataset contenente le tre medie condizionate
combined_data <- bind_rows(
  mean_GPER %>% mutate(group = "All players"),
  mean_GPER_with_year_ge_10 %>% mutate(group = "With Year >= 10"),
  mean_GPER_without_year_ge_10 %>% mutate(group = "Without Year >= 10")
)



# Grafico delle tre medie condizionate
ggplot(combined_data, aes(x = year, y = mean_GPER, color = group)) +
  geom_point() +                 # Punti per ogni osservazione
  geom_line() +                  # Linee che collegano i punti
  labs(title = "E(GPER|Year), (Interval: 1986/87-2023/24, Draft Year <= 2014)",
       x = "Year",
       y = "GPER") +
  theme_minimal() +              # Tema grafico pulito
  scale_color_manual(values = c("All players" = "green",
                                "With Year >= 10" = "blue",
                                "Without Year >= 10" = "red")) # Colori per le linee


# Salva il dataset_NBA_GPER come file RData
save(dataset_NBA_GPER, file = "dataset_NBA_GPER.RData")

# Contare il numero di diversi Player nel dataset
num_players <- dataset_NBA_GPER %>%
  summarize(num_unique_players = n_distinct(Player))

# Stampare il risultato
print(num_players)



################################################################################
################################################################################
################################################################################



### dataset_NBA (Intervallo: 1987/88 - 2023/24) ###

# CREAZIONE dataset_NBA #

# Funzione per scaricare la tabella da un URL specifico
scarica_tabella <- function(url) {
  cat("Scaricando dati da:", url, "\n")  # Messaggio di debug
  pagina <- GET(url)
  
  # Estrarre il contenuto HTML della pagina
  pagina_html <- content(pagina, "text")
  
  # Fare il parsing dell'HTML per renderlo navigabile
  pagina_parsed <- read_html(pagina_html)
  
  # Estrarre la tabella specifica dalla pagina
  tabella <- pagina_parsed %>% html_node("table") %>% html_table(fill = TRUE)
  
  return(tabella)
}

# Lista degli URL dataset_NBA
lista_url <- c(
  "https://stathead.com/tiny/sVymJ",  # URL 1
  "https://stathead.com/tiny/MjGqo",  # URL 2
  "https://stathead.com/tiny/VK17v",  # URL 3
  "https://stathead.com/tiny/GMi0t",  # URL 4
  "https://stathead.com/tiny/WbLxZ",  # URL 5
  "https://stathead.com/tiny/ugXsE",  # URL 6
  "https://stathead.com/tiny/f5fqw",  # URL 7
  "https://stathead.com/tiny/h65Qr",  # URL 8
  "https://stathead.com/tiny/c2gMi",  # URL 9
  "https://stathead.com/tiny/2hMhP",  # URL 10
  "https://stathead.com/tiny/IHveh",  # URL 11
  "https://stathead.com/tiny/gBO34",  # URL 12
  "https://stathead.com/tiny/lHwYG",  # URL 13
  "https://stathead.com/tiny/CkhCt",  # URL 14
  "https://stathead.com/tiny/alZqp",  # URL 15
  "https://stathead.com/tiny/Cq3nh",  # URL 16
  "https://stathead.com/tiny/Hcrzl",  # URL 17
  "https://stathead.com/tiny/HseV7",  # URL 18
  "https://stathead.com/tiny/KNVis",  # URL 19
  "https://stathead.com/tiny/IveBe",  # URL 20
  "https://stathead.com/tiny/g9G9A",  # URL 21
  "https://stathead.com/tiny/3CukT",  # URL 22
  "https://stathead.com/tiny/NiATq",  # URL 23
  "https://stathead.com/tiny/fAxMM",  # URL 24
  "https://stathead.com/tiny/GyBGi",  # URL 25
  "https://stathead.com/tiny/ak1Ye",  # URL 26
  "https://stathead.com/tiny/Wvf7O",  # URL 27
  "https://stathead.com/tiny/U1xXo",  # URL 28
  "https://stathead.com/tiny/ReMCu",  # URL 29
  "https://stathead.com/tiny/LSJUP",  # URL 30
  "https://stathead.com/tiny/Oi7Uk",  # URL 31
  "https://stathead.com/tiny/q9U9A",  # URL 32
  "https://stathead.com/tiny/dX5Pu",  # URL 33
  "https://stathead.com/tiny/aLddA",  # URL 34
  "https://stathead.com/tiny/gNwAD",  # URL 35
  "https://stathead.com/tiny/awhRn",  # URL 36
  "https://stathead.com/tiny/xZbN4",  # URL 37
  "https://stathead.com/tiny/tLrW9",  # URL 38
  "https://stathead.com/tiny/I4d3U",  # URL 39
  "https://stathead.com/tiny/yvUoi"   # URL 40
)



# Inizializza una lista per memorizzare tutte le tabelle
tutte_le_tabelle <- list()

# Ciclo per scaricare le tabelle dai 20 URL
for (url in lista_url) {
  # Scarica la tabella
  tabella <- scarica_tabella(url)
  
  # Aggiungi la tabella scaricata alla lista
  if (!is.null(tabella)) {
    tutte_le_tabelle[[length(tutte_le_tabelle) + 1]] <- tabella
  } else {
    cat("Nessuna tabella trovata per l'URL:", url, "\n")
  }
}

# Combina tutte le tabelle in un unico dataset (verticalmente)
dataset_NBA <- bind_rows(tutte_le_tabelle)


# MANIPOLAZIONE dataset_NBA #

# Rinominare le colonne con i valori della prima riga
colnames(dataset_NBA) <- dataset_NBA[1, ]

# Determina gli indici delle righe da rimuovere: 1, 202, 403, ...
righe_da_rimuovere <- seq(1, nrow(dataset_NBA), by = 201)

# Rimuovi queste righe dal dataset
dataset_NBA <- dataset_NBA[-righe_da_rimuovere, ]

# Trasformare la variabile 'season' prendendo solo il secondo anno
dataset_NBA$Season <- sub(".*-(\\d+)", "\\1", dataset_NBA$Season)

# Aggiungere "19" per anni > 80, "20" per anni <= 80
dataset_NBA$Season <- ifelse(as.numeric(dataset_NBA$Season) > 80,
                             paste0("19", dataset_NBA$Season),
                             paste0("20", dataset_NBA$Season))

# Rimozioni Variabili da dataset_NBA
dataset_NBA <- dataset_NBA %>%
  select(-Rk,-`Ht.`,-Round,-Pick,-`Draft Team`, -College,- Age,- AS,-FG,-FGA,
         -`2P`,-`2PA`,-`3P`,-`3PA`,-FT,-FTA,-PTS,-AST,-TRB,-DRB,-ORB,-STL,-BLK,-TOV,
         -PF,-`FG%`,-`2P%`,-`3P%`,-`FT%`,-`TS%`,-`eFG%`)

# Elenco delle variabili da trasformare in integer
vars_to_integer <- c("Draft Year", "Season", "G", "GS")

# Trasformare le variabili precedenti in integer
dataset_NBA <- dataset_NBA %>%
  mutate(across(all_of(vars_to_integer), as.integer))

# Elenco delle variabili da trasformare in numeric
vars_to_numeric <- c("MP","PER")

# Trasformare le variabili precedenti in numeric
dataset_NBA <- dataset_NBA %>%
  mutate(across(all_of(vars_to_numeric), as.numeric))

# Trasforma la variabile POS in un factor con i livelli specificati
dataset_NBA$Pos <- factor(dataset_NBA$Pos, 
                          levels = c("G", "G-F", "F-G", "F", "F-C", "C-F", "C"))

# Calcola la variabile Year come differenza tra Season e Draft Year
dataset_NBA <- dataset_NBA %>%
  mutate(Year = Season - `Draft Year`)

# Filtra per tenere solo le osservazioni con Year <= 7
dataset_NBA <- dataset_NBA %>%
  filter(Year <= 7)

# Funzione per aggiungere le osservazioni mancanti con statistiche a zero
aggiungi_osservazioni_mancanti <- function(df) {
  # Controlla gli anni già presenti per il Player
  years_present <- df$Year
  years_mancanti <- setdiff(1:7, years_present)  # Trova gli anni mancanti (1 a 7)
  
  # Se non ci sono anni mancanti, restituisci il df originale
  if (length(years_mancanti) == 0) return(df)
  
  # Crea nuove righe per gli anni mancanti
  nuove_righe <- lapply(years_mancanti, function(y) {
    nuova_riga <- df[1, ]  # Copia una riga esistente per il giocatore
    nuova_riga$Year <- y   # Imposta l'anno mancante
    nuova_riga$Season <- nuova_riga$`Draft Year` + y  # Calcola la Season per l'anno
    
    # Imposta tutte le seguenti statistiche a zero
    stats_var <- c("G", "GS", "MP", "PER")
    nuova_riga[stats_var] <- 0
    
    return(nuova_riga)  # Restituisce la nuova riga
  })
  
  # Combina il dataset originale con le nuove righe
  return(bind_rows(df, do.call(rbind, nuove_righe)))
}

# Applica la funzione a ciascun Player per assicurarsi che ogni Player abbia 7 osservazioni
dataset_NBA <- dataset_NBA %>%
  group_by(Player) %>%
  group_modify(~ aggiungi_osservazioni_mancanti(.x)) %>%
  ungroup()

# Sostituisce il valore di "Team" in dataset_NBA con l'ultimo team presente
dataset_NBA$Team <- sub(".*,\\s*", "", dataset_NBA$Team)

# Crea una nuova variabile 'Seasons' che contiene tutte le stagioni con G > 0 per ciascun giocatore
dataset_NBA <- dataset_NBA %>%
  group_by(Player) %>%  # Raggruppa per giocatore
  mutate(Seasons = paste(unique(Season[G > 0]), collapse = ", ")) %>%  # Crea una stringa con tutte le stagioni uniche per ogni giocatore, considerando solo G > 0
  ungroup()  # Rimuovi il raggruppamento

# Crea la variabile MG e assegna il valore 82 di default
dataset_NBA$MG <- 82

# Assegna i valori specifici a MG in base alla Season
dataset_NBA$MG[dataset_NBA$Season == 2021] <- 72
dataset_NBA$MG[dataset_NBA$Season == 2012] <- 66
dataset_NBA$MG[dataset_NBA$Season == 1999] <- 50
dataset_NBA$MG[dataset_NBA$Season %in% c(1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 
                                         1998, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 
                                         2009, 2010, 2011, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 
                                         2022, 2023, 2024)] <- 82

# Crea un vettore di associazione tra Team e il valore di MG per Season 2020
team_games_2020 <- c(
  "DAL" = 75, "POR" = 74, "MIL" = 73, "MIA" = 73, "DEN" = 73, "PHO" = 73, 
  "PHI" = 73, "ORL" = 73, "IND" = 73, "MEM" = 73, "BRK" = 72, "WAS" = 72, 
  "NOP" = 72, "OKC" = 72, "SAC" = 72, "TOR" = 72, "UTA" = 72, "LAC" = 72, 
  "HOU" = 72, "BOS" = 72, "LAL" = 71, "SAS" = 71, "ATL" = 67, "NYK" = 66, 
  "DET" = 66, "GSW" = 65, "CLE" = 65, "CHI" = 65, "CHO" = 65, "MIN" = 64
)

# Applica il valore MG per le osservazioni della Season 2020, in base al Team
dataset_NBA$MG[dataset_NBA$Season == 2020] <- team_games_2020[dataset_NBA$Team[dataset_NBA$Season == 2020]]

# Creare la nuova variabile GPER (PER*MP)
dataset_NBA$GPER <- dataset_NBA$PER * dataset_NBA$MP

# Calcola le percentuali richieste per ogni giocatore
dataset_NBA <- dataset_NBA %>%
  group_by(Player) %>%
  mutate(
    # Somma di G e MG nei primi 3 anni
    GFirst3 = sum(G[Year %in% 1:3], na.rm = TRUE),
    MGFirst3 = sum(MG[Year %in% 1:3], na.rm = TRUE),
    
    # Somma di G e MG negli ultimi 4 anni
    GLast4 = sum(G[Year %in% 4:7], na.rm = TRUE),
    MGLast4 = sum(MG[Year %in% 4:7], na.rm = TRUE),
    
    # Somma di G e MG in tutti i 7 anni
    GAll7 = sum(G, na.rm = TRUE),
    MGAll7 = sum(MG, na.rm = TRUE),
    
    # Calcolo delle percentuali
    `%GFirst3` = ifelse(MGFirst3 > 0, GFirst3 / MGFirst3, 0),  # Gestisce divisione per zero
    `%GLast4` = ifelse(MGLast4 > 0, GLast4 / MGLast4, 0),    # Gestisce divisione per zero
    `%GAll7` = ifelse(MGAll7 > 0, GAll7 / MGAll7, 0)              # Gestisce divisione per zero
  ) %>%
  ungroup()  # Rimuove il raggruppamento

# Rimuovi le seguenti variabili da dataset_NBA
dataset_NBA <- dataset_NBA %>%
  select(-GFirst3, -MGFirst3, -GLast4, -MGLast4, -GAll7, -MGAll7)

# Crea le variabili AGPERAll7, AGPERFirst3 e AGPERLast4 per ogni giocatore
dataset_NBA <- dataset_NBA %>%
  group_by(Player) %>%  # Raggruppa per giocatore
  mutate(
    # Calcola AGPER per tutti gli anni
    AGPERAll7 = sum(GPER * G, na.rm = TRUE) / sum(G, na.rm = TRUE),  # AGPER totale
    # Calcola AGPER per i primi 3 anni
    AGPERFirst3 = sum(GPER[Year <= 3] * G[Year <= 3], na.rm = TRUE) / sum(G[Year <= 3], na.rm = TRUE),  # AGPER primi 3 anni
    # Calcola AGPER per gli ultimi 4 anni
    AGPERLast4 = sum(GPER[Year > 3] * G[Year > 3], na.rm = TRUE) / sum(G[Year > 3], na.rm = TRUE)  # AGPER ultimi 4 anni
  ) %>%
  ungroup()  # Rimuovi il raggruppamento

# Ulteriore rimozione Variabili da dataset_NBA
dataset_NBA <- dataset_NBA %>%
  select(-PER,-Season,-`Draft Year`,-Team,-G,-GS,-MP,-Year,-MG,-GPER)

# Mantieni una sola osservazione per ogni giocatore
dataset_NBA <- dataset_NBA %>%
  distinct(Player, .keep_all = TRUE) 


# Trasforma i valori NaN in 0 per AGPERFirst3 e AGPERLast4
dataset_NBA <- dataset_NBA %>%
  mutate(
    AGPERFirst3 = replace_na(AGPERFirst3, 0),
    AGPERLast4 = replace_na(AGPERLast4, 0)
  )


# Salva il dataset_NBA come file RData
save(dataset_NBA, file = "dataset_NBA.RData")


################################################################################
################################################################################
################################################################################


### dataset_collegeTeams  (Intervallo 1986/87 - 2016/17) ###

# Creazione dataset_NonConfGames #

# Funzione per scaricare la tabella da un URL specifico
scarica_tabella <- function(url) {
  cat("Scaricando dati da:", url, "\n")  
  pagina <- GET(url)
  
  # Estrarre il contenuto HTML della pagina
  pagina_html <- content(pagina, "text")
  
  # Fare il parsing dell'HTML per renderlo navigabile
  pagina_parsed <- read_html(pagina_html)
  
  # Estrarre la tabella specifica dalla pagina
  tabella <- pagina_parsed %>% html_node("table") %>% html_table(fill = TRUE)
  
  return(tabella)
}

# Lista degli URL dataset_NonConfGames
lista_url <- c(
  "https://stathead.com/tiny/Fsd8p",  # URL 1
  "https://stathead.com/tiny/NTPDR"  # URL 2
)


# Inizializza una lista per memorizzare tutte le tabelle
tutte_le_tabelle <- list()

# Ciclo per scaricare le tabelle dagli URL
for (url in lista_url) {
  # Scarica la tabella
  tabella <- scarica_tabella(url)
  
  # Aggiungi la tabella scaricata alla lista (se esiste)
  if (!is.null(tabella)) {
    tutte_le_tabelle[[length(tutte_le_tabelle) + 1]] <- tabella
  } else {
    cat("Nessuna tabella trovata per l'URL:", url, "\n")
  }
}

# Combina tutte le tabelle per generare dataset_NonConfGames
dataset_NonConfGames <- bind_rows(tutte_le_tabelle)

# Elimina le seguenti colonne da dataset_NonConfGamess
dataset_NonConfGames <- dataset_NonConfGames[, -c(1, 3, 4, 6, 7, 8, 9)]

# Rinomina colonna 2 dataset_NonConfGames
colnames(dataset_NonConfGames)[2] <- "NonConfWin%"

# Creazione dataset_NCAAGames (1986/87 - 2017/18) #

# Funzione per scaricare la tabella da un URL specifico
scarica_tabella <- function(url) {
  cat("Scaricando dati da:", url, "\n")  
  pagina <- GET(url)
  
  # Estrarre il contenuto HTML della pagina
  pagina_html <- content(pagina, "text")
  
  # Fare il parsing dell'HTML per renderlo navigabile
  pagina_parsed <- read_html(pagina_html)
  
  # Estrarre la tabella specifica dalla pagina
  tabella <- pagina_parsed %>% html_node("table") %>% html_table(fill = TRUE)
  
  return(tabella)
}

# Lista degli URL dataset_NCAAGames
lista_url <- c(
  "https://stathead.com/tiny/WYHEl",  # URL 1
  "https://stathead.com/tiny/0Yp9l"  # URL 2
)



# Inizializza una lista per memorizzare tutte le tabelle
tutte_le_tabelle <- list()

# Ciclo per scaricare le tabelle dagli URL
for (url in lista_url) {
  # Scarica la tabella
  tabella <- scarica_tabella(url)
  
  # Aggiungi la tabella scaricata alla lista (se esiste)
  if (!is.null(tabella)) {
    tutte_le_tabelle[[length(tutte_le_tabelle) + 1]] <- tabella
  } else {
    cat("Nessuna tabella trovata per l'URL:", url, "\n")
  }
}

# Combina tutte le tabelle per generare dataset_NCAAGames
dataset_NCAAGames <- bind_rows(tutte_le_tabelle)

# Elimina le seguenti colonne da dataset_NCAAGames
dataset_NCAAGames <- dataset_NCAAGames[, -c(1, 3, 4, 7, 8, 9)]

# Rinomina colonna 2 di dataset_NCAAGames
colnames(dataset_NCAAGames)[2] <- "NCAAWin%"

# Rinomina Colonna 3 di dataset_NCAAGames
colnames(dataset_NCAAGames)[3] <- "NCAAGames"

# Portiamo nel range [0,1] la variabile NCAAGames
min_G <- min(dataset_NCAAGames$NCAAGames, na.rm = TRUE)
max_G <- max(dataset_NCAAGames$NCAAGames, na.rm = TRUE)
dataset_NCAAGames$NCAAGames <- (dataset_NCAAGames$NCAAGames - min_G) / (max_G - min_G)


# dataset_CollegeTeams  (intervallo 1986/87 - 2016/2017)#

# Esegui l'inner join tra dataset_Collegenew e dataset_NBAnew basato sui giocatori
dataset_CollegeTeams <- inner_join(dataset_NonConfGames, dataset_NCAAGames, by = "Team")

# Trasforma le variabili espresse in percentuale in numeric di dataset_CollegeTeams
dataset_CollegeTeams$`NCAAWin%` <- as.numeric(dataset_CollegeTeams$`NCAAWin%`)
dataset_CollegeTeams$`NonConfWin%` <- as.numeric(dataset_CollegeTeams$`NonConfWin%`)
dataset_CollegeTeams$NCAAGames <- as.numeric(dataset_CollegeTeams$NCAAGames)

# Crea la variabile NCAAPerformance
dataset_CollegeTeams$NCAAPerformance <- dataset_CollegeTeams$`NCAAWin%` * dataset_CollegeTeams$NCAAGames 

# Crea la variabile CollegePerformance
dataset_CollegeTeams$CollegePerformance <- 0.25 * dataset_CollegeTeams$`NonConfWin%` + 0.75 * dataset_CollegeTeams$NCAAPerformance

# Portiamo nel range [0,1] la variabile CollegePerformance
min_G <- min(dataset_CollegeTeams$CollegePerformance, na.rm = TRUE)
max_G <- max(dataset_CollegeTeams$CollegePerformance, na.rm = TRUE)
dataset_CollegeTeams$CollegePerformance <- (dataset_CollegeTeams$CollegePerformance - min_G) / (max_G - min_G)

# Mantieni solo la colonna CollegePerformance
dataset_CollegeTeams <- dataset_CollegeTeams %>% select(Team, CollegePerformance)

# Rinominare la variabile "Team" in "College"
dataset_CollegeTeams <- dataset_CollegeTeams %>%
  rename(College = Team)

# Carica il pacchetto fastDummies
library(fastDummies)

# Step 1: Creazione della variabile categoriale CollegePerformance_Group basata su intervalli
dataset_CollegeTeams$CollegePerformance_Group <- cut(dataset_CollegeTeams$CollegePerformance,
                                                     breaks = c(-Inf, 0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.80, Inf),
                                                     labels = c("Group8", "Group7", "Group6", "Group5", "Group4", "Group3", "Group2", "Group1"))

# Step 2: Creazione delle variabili dummy per CollegePerformance_Group
dataset_CollegeTeams <- dummy_cols(dataset_CollegeTeams, select_columns = "CollegePerformance_Group", remove_first_dummy = FALSE)


# Rimuovi manualmente la variabile dummy per "Group8" per fare di "Group8" la classe di riferimento
dataset_CollegeTeams <- dataset_CollegeTeams[, !colnames(dataset_CollegeTeams) %in% "CollegePerformance_Group_Group8"]

# Rinomina le variabili CollegePerformance_Group_Group1 in Group1, e così via fino a Group8
names(dataset_CollegeTeams)[names(dataset_CollegeTeams) == "CollegePerformance_Group_Group1"] <- "Group1"
names(dataset_CollegeTeams)[names(dataset_CollegeTeams) == "CollegePerformance_Group_Group2"] <- "Group2"
names(dataset_CollegeTeams)[names(dataset_CollegeTeams) == "CollegePerformance_Group_Group3"] <- "Group3"
names(dataset_CollegeTeams)[names(dataset_CollegeTeams) == "CollegePerformance_Group_Group4"] <- "Group4"
names(dataset_CollegeTeams)[names(dataset_CollegeTeams) == "CollegePerformance_Group_Group5"] <- "Group5"
names(dataset_CollegeTeams)[names(dataset_CollegeTeams) == "CollegePerformance_Group_Group6"] <- "Group6"
names(dataset_CollegeTeams)[names(dataset_CollegeTeams) == "CollegePerformance_Group_Group7"] <- "Group7"
names(dataset_CollegeTeams)[names(dataset_CollegeTeams) == "CollegePerformance_Group_Group8"] <- "Group8"


# Salva il dataset_College_Teams come file RData
save(dataset_CollegeTeams, file = "dataset_CollegeTeams.RData")



################################################################################
################################################################################
################################################################################

### dataset_College (Intervallo 1986/87 - 2016/17) ###

# Creazione dataset_College #

# Funzione per scaricare la tabella da un URL specifico
scarica_tabella <- function(url) {
  cat("Scaricando dati da:", url, "\n")  
  pagina <- GET(url)
  
  # Estrarre il contenuto HTML della pagina
  pagina_html <- content(pagina, "text")
  
  # Fare il parsing dell'HTML per renderlo navigabile
  pagina_parsed <- read_html(pagina_html)
  
  # Estrarre la tabella specifica dalla pagina
  tabella <- pagina_parsed %>% html_node("table") %>% html_table(fill = TRUE)
  
  return(tabella)
}

# Lista degli URL dataset_College
lista_url <- c(
  "https://stathead.com/tiny/ktSSd",  # URL 1
  "https://stathead.com/tiny/ztl1w",  # URL 2
  "https://stathead.com/tiny/Pp0o7",  # URL 3
  "https://stathead.com/tiny/gSl1c",  # URL 4
  "https://stathead.com/tiny/VmBMA",  # URL 5
  "https://stathead.com/tiny/JAR0G",  # URL 6
  "https://stathead.com/tiny/MDslz",  # URL 7
  "https://stathead.com/tiny/u6UPg",  # URL 8
  "https://stathead.com/tiny/1QjJa",  # URL 9
  "https://stathead.com/tiny/zMMP0",  # URL 10
  "https://stathead.com/tiny/rYpek",  # URL 11
  "https://stathead.com/tiny/5QexD",  # URL 12
  "https://stathead.com/tiny/tgMSS",  # URL 13
  "https://stathead.com/tiny/6CD1K",  # URL 14
  "https://stathead.com/tiny/yekLa",  # URL 15
  "https://stathead.com/tiny/PqPh8",  # URL 16
  "https://stathead.com/tiny/6tgiV",  # URL 17 
  "https://stathead.com/tiny/YdvAF",  # URL 18
  "https://stathead.com/tiny/oPKTu",  # URL 19
  "https://stathead.com/tiny/dk2b4",  # URL 20
  "https://stathead.com/tiny/GcBKd",  # URL 21
  "https://stathead.com/tiny/BuJrL",  # URL 22
  "https://stathead.com/tiny/xodnF"   # URL 23
)



# Inizializza una lista per memorizzare tutte le tabelle
tutte_le_tabelle <- list()

# Ciclo per scaricare le tabelle dagli URL
for (url in lista_url) {
  # Scarica la tabella
  tabella <- scarica_tabella(url)
  
  # Aggiungi la tabella scaricata alla lista (se esiste)
  if (!is.null(tabella)) {
    tutte_le_tabelle[[length(tutte_le_tabelle) + 1]] <- tabella
  } else {
    cat("Nessuna tabella trovata per l'URL:", url, "\n")
  }
}

# Combina tutte le tabelle in un unico dataset (verticalmente)
dataset_College <- bind_rows(tutte_le_tabelle)


# MANIPOLAZIONE dataset_College #

# Rinominare le colonne con i valori della prima riga
colnames(dataset_College) <- dataset_College[1, ]

# Determina gli indici delle righe da rimuovere: 1, 202, 403, ...
righe_da_rimuovere <- seq(1, nrow(dataset_College), by = 201)

# Rimuovi queste righe dal dataset
dataset_College <- dataset_College[-righe_da_rimuovere, ]

# Trasformare la variabile 'season' prendendo solo il secondo anno
dataset_College$Season <- sub(".*-(\\d+)", "\\1", dataset_College$Season)

# Aggiungere "19" per anni > 80, "20" per anni <= 80
dataset_College$Season <- ifelse(as.numeric(dataset_College$Season) > 80,
                                 paste0("19", dataset_College$Season),
                                 paste0("20", dataset_College$Season))

# Filtrare il dataset per mantenere solo le osservazioni dove 'Draft Year' è uguale a 'Season'
dataset_College <- dataset_College %>% filter(`Draft Year` == Season)

# Rinominare la variabile Ht. in Ht
colnames(dataset_College)[colnames(dataset_College) == "Ht."] <- "Ht"

# Rinominare la variabile Draft College
dataset_College <- dataset_College %>% rename(College = `Draft College`)

# Funzione per convertire Ht da 'piedi-pollici' a centimetri
convert_to_cm <- function(height) {
  # Dividere la stringa "piedi-pollici" usando il trattino come separatore
  parts <- strsplit(height, "-")[[1]]
  feet <- as.numeric(parts[1])  # n (piedi)
  inches <- as.numeric(parts[2])  # m (pollici)
  
  # Convertire piedi e pollici in centimetri (1 piede = 30.48 cm, 1 pollice = 2.54 cm)
  height_cm <- (feet * 30.48) + (inches * 2.54)
  return(height_cm)
}

# Applicare la funzione alla colonna Ht per creare la nuova variabile Height
dataset_College$Height <- sapply(dataset_College$Ht, convert_to_cm)

# Rimozione seguenti variabili da dataset_College
dataset_College <- dataset_College %>%
  select(-Rk,-Ht,-Round,-Pick,-Team,-ORB,-DRB,-Pos,-`Draft Team`,-Season, -FG,
         -FGA, -`2P`, -`3P`, -FT, -PF, -`TS%`, -`eFG%` )

# Elenco delle variabili da trasformare in integer
vars_to_integer <- c("Draft Year", "G", "GS")

# Trasformare le variabili precedenti in integer
dataset_College <- dataset_College %>%
  mutate(across(all_of(vars_to_integer), as.integer))

# Elenco delle variabili da trasformare in numeric
vars_to_numeric <- c("2PA", "3PA", "FTA", "TRB", 
                     "AST", "STL", "BLK", "TOV", "PTS", "Height", "MP")

# Trasformare le variabili precedenti in numeric
dataset_College <- dataset_College %>%
  mutate(across(all_of(vars_to_numeric), as.numeric))

# Trasforma le variabili espresse in percentuale in numeric
dataset_College$`2P%` <- as.numeric(dataset_College$`2P%`)
dataset_College$`3P%` <- as.numeric(dataset_College$`3P%`)
dataset_College$`FT%` <- as.numeric(dataset_College$`FT%`)
dataset_College$`FG%` <- as.numeric(dataset_College$`FG%`)

# Crea le variabili dummy senza rimuovere la prima automaticamente
dataset_College <- dummy_cols(dataset_College, select_columns = "Class", remove_first_dummy = FALSE)

# Rimuovi manualmente la variabile dummy per "Class_SR" per fare di "SR" la classe di riferimento
dataset_College <- dataset_College[, !colnames(dataset_College) %in% "Class_SR"]
# La classe di riferimento è SR

# Inner Join tra dataset_College e dataset_CollegeTeams
dataset_College <- inner_join(dataset_College, dataset_CollegeTeams, by = "College")


# Salva il dataset_College come file RData
save(dataset_College, file = "dataset_College.RData")




################################################################################
################################################################################
################################################################################


### Dataset_Tesina (intervallo College 1986/87 - 2016/17, intervallo NBA 1987/88 - 2023/24) ###

# Esegui l'inner join tra dataset_College e dataset_NBA by Player
dataset_Tesina <- inner_join(dataset_College, dataset_NBA, by = "Player")

# Creazione della nuova variabile "OtherStats" come somma di Stl, Block e -Turn
dataset_Tesina$OtherStats <- dataset_Tesina$STL + dataset_Tesina$BLK - dataset_Tesina$TOV

# Sostituzione dei valori NA di 3P% CON 0.000 e dei valori NA di OtherStats con 0.0
dataset_Tesina <- dataset_Tesina %>%
  mutate(
    `3P%` = ifelse(is.na(`3P%`), 0.000, `3P%`),
    OtherStats = ifelse(is.na(OtherStats), 0.0, OtherStats)
  )

# Portare i valori infinitesimi di OtherStats a 0.0
dataset_Tesina$OtherStats <- round(dataset_Tesina$OtherStats, 3)

# Rimozione seguenti variabili da dataset_Tesina
dataset_Tesina <- dataset_Tesina %>%
  select(-STL, -BLK,-TOV,-G,-GS,-CollegePerformance )

# Modifica ordine colonne dataset_Tesina
dataset_Tesina <- dataset_Tesina[, c("Player", "Pos", "Height","MP","2P%","2PA",
                                     "3P%","3PA","FT%","FTA","FG%","PTS","AST","TRB","OtherStats",
                                     "Class", "Class_FR", "Class_SO","Class_JR",
                                     "Draft Year","Seasons","College","CollegePerformance_Group",
                                     "Group1","Group2","Group3","Group4","Group5","Group6","Group7",
                                     "%GFirst3","%GLast4","%GAll7","AGPERFirst3","AGPERLast4","AGPERAll7")]

# Rinomina la seguenti variabili di dataset_Tesina
names(dataset_Tesina)[names(dataset_Tesina) == "Draft Year"] <- "Draft_Year"
names(dataset_Tesina)[names(dataset_Tesina) == "2P%"] <- "Two_perc"
names(dataset_Tesina)[names(dataset_Tesina) == "3P%"] <- "Three_perc"
names(dataset_Tesina)[names(dataset_Tesina) == "FT%"] <- "FT_perc"
names(dataset_Tesina)[names(dataset_Tesina) == "2PA"] <- "TwoA"
names(dataset_Tesina)[names(dataset_Tesina) == "3PA"] <- "ThreeA"
names(dataset_Tesina)[names(dataset_Tesina) == "FG%"] <- "FG_perc"


# Crea la variabile AGPERFirst3Mod con le condizioni specificate
dataset_Tesina <- dataset_Tesina %>%
  mutate(
    AGPERFirst3Mod = case_when(
      `%GFirst3` > 0.20 ~ AGPERFirst3,
      `%GFirst3` >= 0.15 & `%GFirst3` < 0.20 ~ AGPERFirst3 * 0.75,
      `%GFirst3` >= 0.10 & `%GFirst3` < 0.15 ~ AGPERFirst3 * 0.50,
      `%GFirst3` >= 0.05 & `%GFirst3` < 0.10 ~ AGPERFirst3 * 0.25,
      `%GFirst3` >= 0.00 & `%GFirst3` < 0.05 ~ AGPERFirst3 * 0.00,
      TRUE ~ NA_real_  # Opzione per assegnare NA se nessuna condizione è soddisfatta
    )
  )


# Crea la variabile AGPERLast4Mod con le condizioni specificate
dataset_Tesina <- dataset_Tesina %>%
  mutate(
    AGPERLast4Mod = case_when(
      `%GLast4` > 0.20 ~ AGPERLast4,
      `%GLast4` >= 0.15 & `%GLast4` < 0.20 ~ AGPERLast4 * 0.75,
      `%GLast4` >= 0.10 & `%GLast4` < 0.15 ~ AGPERLast4 * 0.50,
      `%GLast4` >= 0.05 & `%GLast4` < 0.10 ~ AGPERLast4 * 0.25,
      `%GLast4` >= 0.00 & `%GLast4` < 0.05 ~ AGPERLast4 * 0.00,
      TRUE ~ NA_real_
    )
  )


# Crea la variabile AGPERAll7Mod con le condizioni specificate
dataset_Tesina <- dataset_Tesina %>%
  mutate(
    AGPERAll7Mod = case_when(
      `%GAll7` > 0.20 ~ AGPERAll7,
      `%GAll7` >= 0.15 & `%GAll7` < 0.20 ~ AGPERAll7 * 0.75,
      `%GAll7` >= 0.10 & `%GAll7` < 0.15 ~ AGPERAll7 * 0.50,
      `%GAll7` >= 0.05 & `%GAll7` < 0.10 ~ AGPERAll7 * 0.25,
      `%GAll7` >= 0.00 & `%GAll7` < 0.05 ~ AGPERAll7 * 0.00,
      TRUE ~ NA_real_
    )
  )

# Rinomina la seguenti variabili di dataset_Tesina
names(dataset_Tesina)[names(dataset_Tesina) == "%GFirst3"] <- "perc_GFirstThree"
names(dataset_Tesina)[names(dataset_Tesina) == "%GLast4"] <- "perc_GLastFour"
names(dataset_Tesina)[names(dataset_Tesina) == "%GAll7"] <- "perc_GAll7"

# Trasforma le variabili da decimali a percentuali
dataset_Tesina$Two_perc <- dataset_Tesina$Two_perc * 100
dataset_Tesina$Three_perc <- dataset_Tesina$Three_perc * 100
dataset_Tesina$FT_perc <- dataset_Tesina$FT_perc * 100

# Trasforma la variabile Draft_Year in variabile factor per permettere plm
dataset_Tesina$Draft_Year <- as.factor(dataset_Tesina$Draft_Year)

# Trasforma il dataset in data.frame
dataset_Tesina <- as.data.frame(dataset_Tesina)

# Rimozione seguenti variabili da dataset_Tesina
dataset_Tesina <- dataset_Tesina %>%
  select(-MP, -Seasons,-College,-perc_GFirstThree,-perc_GLastFour,- perc_GAll7,
         -AGPERFirst3, -AGPERAll7, -AGPERFirst3Mod, -AGPERAll7Mod, -AGPERLast4)

# Rinomina la seguente variabile di dataset_Tesina
names(dataset_Tesina)[names(dataset_Tesina) == "AGPERLast4Mod"] <- "GPER_Prime"

# Rimozione seguenti variabili da dataset_Tesina
dataset_Tesina <- dataset_Tesina %>%
  select(-FG_perc,-PTS)


# Salva il dataset_tesina come file RData
save(dataset_Tesina, file = "dataset_Tesina.RData")

