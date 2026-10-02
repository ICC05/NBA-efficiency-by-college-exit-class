### TESINA INTERNA SCUOLA SUPERIORE SANT'ANNA ###
### IACOPO CARDOSI CARRARA ###
### MASTER OF SCIENCE IN ECONOMICS (QF) ###
### ANALISI Dataset_Tesina ###


### IMPOSTAZIONI INIZIALI CODICE ###   

# Impostare la Working Directory
setwd("C:/Users/iacoc/OneDrive/Desktop/Tesina")

# Scarica pacchetti necessari
install.packages("caret") # Per la Cross-Validation
install.packages("car")  # Per test di multicollineraità
install.packages("lmtest") # Per test di autocorrelazione 
install.packages("sandwich") # Per errori standard robusti
install.packages("plm") # Per l'analisi pooled cross-section 
install.packages("strucchange")
install.packages("stargazer") # Per creare tabelle riassuntive in formato testo o LaTeX
install.packages("plm") # per regression Pooled
install.packages("clubSandwich")
install.packages("wooldridge")
install.packages("tseries") # per Jarque Bera test

# Caricamento dei pacchetti precedenti
library(caret)
library(sandwich)
library(lmtest)
library(plm)
library(car)
library(dplyr)
library(strucchange)
library(stargazer) 
library(clubSandwich)
library(wooldridge)
library(tseries)

# Caricamento del dataset
load("dataset_Tesina.RData")

# Divisione delle osservazioni di dataset_Tesina nei tre subsets RoleG, RoleF, RoleC 
RoleG <- subset(dataset_Tesina, Pos %in% c("G", "G-F"))
RoleF <- subset(dataset_Tesina, Pos %in% c("G-F","F", "F-G", "F-C"))
RoleC <- subset(dataset_Tesina, Pos %in% c("F-C","C-F", "C"))


# Salva RoelG, RoleF e RoleC come file .RData
save(RoleG, file = "RoleG.RData")
save(RoleF, file = "RoleF.RData")
save(RoleC, file = "RoleC.RData")




### ROLEG ANALISYS ###

### CROSS-VALIDATION TRA MODELLI CON E SENZA DUMMIES TEMPORALI ###

# Imposta la variabile di risposta e le variabili predittive
response_var <- "GPER_Prime"
predictors <- c("Class", "CollegePerformance_Group", "Height", 
                "Two_perc", "Three_perc", "TwoA", "ThreeA", 
                "FT_perc", "FTA", "AST", "TRB", "OtherStats")

# Crea una formula per il modello senza effetti di anno
formula_no_year <- as.formula(paste(response_var, "~", paste(predictors, collapse = " + ")))

# Crea una formula per il modello con dummy per anno
formula_with_year <- as.formula(paste(response_var, "~", paste(c(predictors, "factor(Draft_Year)"), collapse = " + ")))

# Imposta la procedura di cross-validation (10-fold)
control <- trainControl(method = "cv", number = 10)

# Esegui la cross-validation per il modello senza dummy per anno
model_no_year_cv <- train(formula_no_year, data = RoleG, method = "lm", trControl = control)

# Esegui la cross-validation per il modello con dummy per anno
model_with_year_cv <- train(formula_with_year, data = RoleG, method = "lm", trControl = control)

# Risultati della validazione incrociata
cat("RMSE per il modello senza dummy per anno:", model_no_year_cv$results$RMSE, "\n")
cat("RMSE per il modello con dummy per anno:", model_with_year_cv$results$RMSE, "\n")

# Confronto tra i due modelli
if (model_with_year_cv$results$RMSE < model_no_year_cv$results$RMSE) {
  cat("Il modello con dummy per anno ha una migliore capacità predittiva.\n")
} else {
  cat("Il modello senza dummy per anno è sufficiente per la capacità predittiva.\n")
}



### DEFINIZIONE DEL MODELLO: Pooled_OLS_ModelG ###

# Definisci la formula del modello finale
Pooled_OLS_ModelG <- GPER_Prime ~ Class + CollegePerformance_Group + Height + 
  Two_perc + Three_perc + TwoA + ThreeA + FT_perc + 
  FTA + AST + TRB + OtherStats

# Stima il modello pooled OLS senza dummy per anno
Pooled_OLS_ModelG <- lm(Pooled_OLS_ModelG, data = RoleG)

summary(Pooled_OLS_ModelG)


### CONTROLLO ETEROSCHEDASTICITA ###

# l'obiettivo è determinare se sia necessario utilizzare errori standard robusti all'eteroschedasticità

# Test di Breusch-Pagan sul modello
bptest(Pooled_OLS_ModelG)

# Modello con errori standard robusti HC3
coeftest(Pooled_OLS_ModelG, vcov = vcovHC(Pooled_OLS_ModelG, type = "HC3"))


### CONTROLLO AUTOCORRELAZIONE DEGLI ERRORI ALL'INTERNO DELLO STESSO ANNO ###

# L'obiettivo è determinare se la clusterizzazione degli errori per anno sia necessaria o no

# Test di Wooldridge #
# Converte i dati in formato panel
panel_data <- pdata.frame(RoleG, index = c("Draft_Year", "Player"))  

# Esegui il test di Wooldridge
pwartest(GPER_Prime ~ Class + CollegePerformance_Group + Height + 
           Two_perc + Three_perc + TwoA + ThreeA + FT_perc + FTA + AST + TRB + OtherStats, 
         data = panel_data)


# Errori standard clusterizzati per anno
summary_cluster <- coeftest(Pooled_OLS_ModelG, vcov = vcovCL(Pooled_OLS_ModelG, cluster = ~ Draft_Year))

# print summary_cluster
print(summary_cluster)



### VERIFICA DELLA MULTICOLLINEARITA: GENERALIZED VARIANCE INFLATION FACTOR (GVIF) ###

# L'obiettivo è contrallere la presenza di multicollinearità tra i regressori

# GVIF Test
vif(Pooled_OLS_ModelG)





### ROLEF ANALISYS ###

### CROSS-VALIDATION TRA MODELLI CON E SENZA DUMMIES TEMPORALI ###

# Imposta la variabile di risposta e le variabili predittive
response_var <- "GPER_Prime"
predictors <- c("Class", "CollegePerformance_Group", "Height", 
                "Two_perc", "Three_perc", "TwoA", "ThreeA", 
                "FT_perc", "FTA", "AST", "TRB", "OtherStats")

# Crea una formula per il modello senza effetti di anno
formula_no_year <- as.formula(paste(response_var, "~", paste(predictors, collapse = " + ")))

# Crea una formula per il modello con dummy per anno
formula_with_year <- as.formula(paste(response_var, "~", paste(c(predictors, "factor(Draft_Year)"), collapse = " + ")))

# Imposta la procedura di cross-validation (10-fold)
control <- trainControl(method = "cv", number = 10)

# Esegui la cross-validation per il modello senza dummy per anno
model_no_year_cv <- train(formula_no_year, data = RoleF, method = "lm", trControl = control)

# Esegui la cross-validation per il modello con dummy per anno
model_with_year_cv <- train(formula_with_year, data = RoleF, method = "lm", trControl = control)

# Risultati della validazione incrociata
cat("RMSE per il modello senza dummy per anno:", model_no_year_cv$results$RMSE, "\n")
cat("RMSE per il modello con dummy per anno:", model_with_year_cv$results$RMSE, "\n")

# Confronto tra i due modelli
if (model_with_year_cv$results$RMSE < model_no_year_cv$results$RMSE) {
  cat("Il modello con dummy per anno ha una migliore capacità predittiva.\n")
} else {
  cat("Il modello senza dummy per anno è sufficiente per la capacità predittiva.\n")
}


### DEFINIZIONE DEL MODELLO: Pooled_OLS_ModelF ###

# Definisci la formula del modello finale
Pooled_OLS_ModelF <- GPER_Prime ~ Class + CollegePerformance_Group + Height + 
  Two_perc + Three_perc + TwoA + ThreeA + FT_perc + 
  FTA + AST + TRB + OtherStats

# Stima il modello pooled OLS senza dummy per anno
Pooled_OLS_ModelF <- lm(Pooled_OLS_ModelF, data = RoleF)

summary(Pooled_OLS_ModelF)


### CONTROLLO ETEROSCHEDASTICITA ###

# l'obiettivo è determinare se sia necessario utilizzare errori standard robusti all'eterschedasticità

# Test di Breusch-Pagan sul modello
bptest(Pooled_OLS_ModelF)

# Modello con errori standard robusti HC3
coeftest(Pooled_OLS_ModelF, vcov = vcovHC(Pooled_OLS_ModelF, type = "HC3"))


### CONTROLLO AUTOCORRELAZIONE DEGLI ERRORI ALL'INTERNO DELLO STESSO ANNO ###

# L'obiettivo è determinare se la clusetrizzazione degli errori per anno sia necessaria o no


# Converte i dati in formato panel
panel_data <- pdata.frame(RoleF, index = c("Draft_Year", "Player"))  

# Esegui il test di Wooldridge
pwartest(GPER_Prime ~ Class + CollegePerformance_Group + Height + 
           Two_perc + Three_perc + TwoA + ThreeA + FT_perc + FTA + AST + TRB + OtherStats, 
         data = panel_data)


# Errori standard clusterizzati per anno
summary_cluster <- coeftest(Pooled_OLS_ModelF, vcov = vcovCL(Pooled_OLS_ModelF, cluster = ~ Draft_Year))

# print summary_cluster
print(summary_cluster)




### VERIFICA DELLA MULTICOLLINEARITA: GENERALIZED VARIANCE INFLATION FACTOR (GVIF) ###

# L'obietticvo è controllare per òa presenza di multicollinearità tra residui

# GVIF Test
vif(Pooled_OLS_ModelF)




### ROLEC ANALISYS ###

### CROSS-VALIDATION TRA MODELLI CON E SENZA DUMMIES TEMPORALI ###

# Imposta la variabile di risposta e le variabili predittive
response_var <- "GPER_Prime"
predictors <- c("Class", "CollegePerformance_Group", "Height", 
                "Two_perc", "Three_perc", "TwoA", "ThreeA", 
                "FT_perc", "FTA", "AST", "TRB", "OtherStats")

# Crea una formula per il modello senza effetti di anno
formula_no_year <- as.formula(paste(response_var, "~", paste(predictors, collapse = " + ")))

# Crea una formula per il modello con dummy per anno
formula_with_year <- as.formula(paste(response_var, "~", paste(c(predictors, "factor(Draft_Year)"), collapse = " + ")))

# Imposta la procedura di cross-validation (10-fold)
control <- trainControl(method = "cv", number = 10)

# Esegui la cross-validation per il modello senza dummy per anno
model_no_year_cv <- train(formula_no_year, data = RoleC, method = "lm", trControl = control)

# Esegui la cross-validation per il modello con dummy per anno
model_with_year_cv <- train(formula_with_year, data = RoleC, method = "lm", trControl = control)

# Risultati della validazione incrociata
cat("RMSE per il modello senza dummy per anno:", model_no_year_cv$results$RMSE, "\n")
cat("RMSE per il modello con dummy per anno:", model_with_year_cv$results$RMSE, "\n")

# Confronto tra i due modelli
if (model_with_year_cv$results$RMSE < model_no_year_cv$results$RMSE) {
  cat("Il modello con dummy per anno ha una migliore capacità predittiva.\n")
} else {
  cat("Il modello senza dummy per anno è sufficiente per la capacità predittiva.\n")
}


### DEFINIZIONE DEL MODELLO: Pooled_OLS_ModelC ###

# Definisci la formula del modello finale
Pooled_OLS_ModelC <- GPER_Prime ~ Class + CollegePerformance_Group + Height + 
  Two_perc + Three_perc + TwoA + ThreeA + FT_perc + 
  FTA + AST + TRB + OtherStats

# Stima il modello pooled OLS senza dummy per anno
Pooled_OLS_ModelC <- lm(Pooled_OLS_ModelC, data = RoleC)

summary(Pooled_OLS_ModelC)


### CONTROLLO ETEROSCHEDASTICITA ###

# l'obiettivo è determinare se sia necessario utilizzare errori standard robusti all'eterschedasticità

# Test di Breusch-Pagan sul modello
bptest(Pooled_OLS_ModelC)

# Modello con errori standard robusti HC3
coeftest(Pooled_OLS_ModelC, vcov = vcovHC(Pooled_OLS_ModelC, type = "HC3"))




### CONTROLLO AUTOCORRELAZIONE DEGLI ERRORI ALL'INTERNO DELLO STESSO ANNO ###

# L'obiettivo è determinare se la clusetrizzazione degli errori per anno sia necessaria o no

# Test di Wooldridge #
# Converte i dati in formato panel
panel_data <- pdata.frame(RoleC, index = c("Draft_Year", "Player"))  

# Esegui il test di Wooldridge
pwartest(GPER_Prime ~ Class + CollegePerformance_Group + Height + 
           Two_perc + Three_perc + TwoA + ThreeA + FT_perc + FTA + AST + TRB + OtherStats, 
         data = panel_data)


# Errori standard clusterizzati per anno
summary_cluster <- coeftest(Pooled_OLS_ModelC, vcov = vcovCL(Pooled_OLS_ModelC, cluster = ~ Draft_Year))

# print summary_cluster
print(summary_cluster)




### VERIFICA DELLA MULTICOLLINEARITA: GENERALIZED VARIANCE INFLATION FACTOR (GVIF) ###

# L'obiettivo è controllare per la multicollinearità tra i regressori

# GVIF Test
vif(Pooled_OLS_ModelC)





