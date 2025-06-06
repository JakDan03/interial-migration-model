# biblioteki
if (!require("readxl")) { install.packages("readxl"); library(readxl) }
if (!require("whitestrap")) { install.packages("whitestrap"); library(whitestrap) }
if (!require("estimatr")) { install.packages("estimatr"); library(estimatr) }
if (!require("modelsummary")) { install.packages("modelsummary"); library(modelsummary) }
if (!require("dplyr")) { install.packages("dplyr"); library(dplyr) }
if (!require("flextable")) { install.packages("flextable"); library(flextable) }
if (!require("officer")) { install.packages("officer"); library(officer) }
if (!require("ggplot2")) { install.packages("ggplot2"); library(ggplot2) }

#czyszczenie danych
rm(list=ls())

#excel z danymi
data = read_excel("Data/data.xlsx")

# podsumowanie
summary(data)

# zmienne zero-jedynkowe - województwa
data$DOLNOSLASKIE = ifelse(data$WOZ == "dolnośląskie", 1, 0)
data$KUJAWSKOPOMORSKIE = ifelse(data$WOZ == "kujawsko-pomorskie", 1, 0)
data$LUBELSKIE = ifelse(data$WOZ == "lubelskie", 1, 0)
data$LUBUSKIE = ifelse(data$WOZ == "lubuskie", 1, 0)
data$LODZKIE = ifelse(data$WOZ == "łódzkie", 1, 0)
data$MALOPOLSKIE = ifelse(data$WOZ == "małopolskie", 1, 0)
data$MAZOWIECKIE = ifelse(data$WOZ == "mazowieckie", 1, 0)
data$OPOLSKIE = ifelse(data$WOZ == "opolskie", 1, 0)
data$PODKARPACKIE = ifelse(data$WOZ == "podkarpackie", 1, 0)
data$PODLASKIE = ifelse(data$WOZ == "podlaskie", 1, 0)
data$POMORSKIE = ifelse(data$WOZ == "pomorskie", 1, 0)
data$SLASKIE = ifelse(data$WOZ == "śląskie", 1, 0)
data$SWIETOKRZYSKIE = ifelse(data$WOZ == "świętokrzyskie", 1, 0)
data$WARMINSKOMAZURSKIE = ifelse(data$WOZ == "warmińsko-mazurskie", 1, 0)
data$WIELKOPOLSKIE = ifelse(data$WOZ == "wielkopolskie", 1, 0)
data$ZACHODNIOPOMORSKIE = ifelse(data$WOZ == "zachodniopomorskie", 1, 0)

# podział danych na dwa okresy: 2004-2011 oraz 2016-2023
data1 = data[data$ROK < 2012 & data$ROK > 2003,]
data2 = data[data$ROK > 2015,]

# model podstawowy, lata 2004-2011
model1_1 = lm(log(FLOW) ~ log(POP_WOZ_LAG) + log(POP_WWZ_LAG) + log(DIST_LAG), data=data1)
summary(model1_1)

# model podstawowy, lata 2016-2023
model1_2 = lm(log(FLOW) ~ log(POP_WOZ_LAG) + log(POP_WWZ_LAG) + log(DIST_LAG), data=data2)
summary(model1_2)

# model z efektami stałymi dla województw i lat oraz stopą bezrobocia i PKB 
# (baseline - świętokrzyskie, lata 2004-2011)
model2_1 = lm(log(FLOW) ~ log(POP_WOZ_LAG) + log(POP_WWZ_LAG) + log(DIST_LAG) +
                log(UNEMP_WOZ_LAG) + log(UNEMP_WWZ_LAG) + 
                log(PKB_WOZ_LAG) + log(PKB_WWZ_LAG) + 
                DOLNOSLASKIE + KUJAWSKOPOMORSKIE + LUBELSKIE + LUBUSKIE +
                LODZKIE + MALOPOLSKIE + MAZOWIECKIE + OPOLSKIE + 
                PODKARPACKIE + PODLASKIE + POMORSKIE + SLASKIE + 
                WARMINSKOMAZURSKIE + WIELKOPOLSKIE + ZACHODNIOPOMORSKIE, data = data1)
summary(model2_1)

# model z efektami stałymi dla województw i lat oraz stopą bezrobocia i PKB 
# (baseline - świętokrzyskie, lata 2016-2023)
model2_2 = lm(log(FLOW) ~ log(POP_WOZ_LAG) + log(POP_WWZ_LAG) + log(DIST_LAG) +
                log(UNEMP_WOZ_LAG) + log(UNEMP_WWZ_LAG) + 
                log(PKB_WOZ_LAG) + log(PKB_WWZ_LAG) + 
                DOLNOSLASKIE + KUJAWSKOPOMORSKIE + LUBELSKIE + LUBUSKIE +
                LODZKIE + MALOPOLSKIE + MAZOWIECKIE + OPOLSKIE + 
                PODKARPACKIE + PODLASKIE + POMORSKIE + SLASKIE + 
                WARMINSKOMAZURSKIE + WIELKOPOLSKIE + ZACHODNIOPOMORSKIE, data = data2)
summary(model2_2)

# test na heteroskedastyczność
white_test(model1_1)
white_test(model1_2)
white_test(model2_1)
white_test(model2_2)

# błędy odporne na heteroskedastyczność
model1_1_robust = lm_robust(log(FLOW) ~ log(POP_WOZ_LAG) + log(POP_WWZ_LAG) + 
                              log(DIST_LAG), data=data1, se_type = "HC0")
model1_2_robust = lm_robust(log(FLOW) ~ log(POP_WOZ_LAG) + log(POP_WWZ_LAG) + 
                              log(DIST_LAG), data=data2, se_type = "HC0")
model2_1_robust = lm_robust(log(FLOW) ~ log(POP_WOZ_LAG) + log(POP_WWZ_LAG) + log(DIST_LAG) +
                              log(UNEMP_WOZ_LAG) + log(UNEMP_WWZ_LAG) + 
                              log(PKB_WOZ_LAG) + log(PKB_WWZ_LAG) + 
                              DOLNOSLASKIE + KUJAWSKOPOMORSKIE + LUBELSKIE + 
                              LUBUSKIE + LODZKIE + MALOPOLSKIE + MAZOWIECKIE + 
                              OPOLSKIE + PODKARPACKIE + PODLASKIE + POMORSKIE + 
                              SLASKIE + WARMINSKOMAZURSKIE + WIELKOPOLSKIE + 
                              ZACHODNIOPOMORSKIE, data = data1, se_type = "HC0")
model2_2_robust = lm_robust(log(FLOW) ~ log(POP_WOZ_LAG) + log(POP_WWZ_LAG) + log(DIST_LAG) +
                              log(UNEMP_WOZ_LAG) + log(UNEMP_WWZ_LAG) + 
                              log(PKB_WOZ_LAG) + log(PKB_WWZ_LAG) + 
                              DOLNOSLASKIE + KUJAWSKOPOMORSKIE + LUBELSKIE + 
                              LUBUSKIE + LODZKIE + MALOPOLSKIE + MAZOWIECKIE + 
                              OPOLSKIE + PODKARPACKIE + PODLASKIE + POMORSKIE + 
                              SLASKIE + WARMINSKOMAZURSKIE + WIELKOPOLSKIE + 
                              ZACHODNIOPOMORSKIE, data = data2, se_type = "HC0")

# porównanie modeli
modelsummary(
  list(
    "Bazowy 2003–2010" = model1_1_robust,
    "Bazowy 2016–2023" = model1_2_robust,
    "Rozszerzony 2003–2010" = model2_1_robust,
    "Rozszerzony 2016–2023" = model2_2_robust
  ),
  estimate = "{estimate}{stars} ({std.error})",
  stars = c("*" = 0.1, "**" = 0.05, "***" = 0.01),
  statistic = NULL,
  notes = c(
    "*** p < 0.01, ** p < 0.05, * p < 0.1",
    output = "C:/Users/qb4co/Desktop/licencjat/tabela modele.docx"
  )
)

# -------------------------------------------------------------------------------

# do wykresów dla efektów wojewódzkich

# Funkcja pomocnicza do ekstrakcji współczynników i przedziałów ufności
extract_ci <- function(model, start = 9, end = 23, level = 0.95) {
  coefs <- model$coefficients[start:end]
  ses <- model$std.error[start:end]
  z <- qnorm(1 - (1 - level) / 2)  # wartość krytyczna dla 95% CI
  
  data.frame(
    variable = names(coefs),
    estimate = coefs,
    ci_lower = coefs - z * ses,
    ci_upper = coefs + z * ses
  )
}

# Zastosowanie do obu modeli
ci_model2_1 <- extract_ci(model2_1_robust)
ci_model2_2 <- extract_ci(model2_2_robust)

# Przygotuj dane: uszereguj i dodaj kolumnę dla koloru punktu
ci_model2_1_plot <- ci_model2_1 %>%
  arrange(estimate) %>%
  mutate(
    variable = factor(variable, levels = variable),
    kolor = case_when(
      estimate > 0 & ci_lower > 0 ~ "czarny",          # istotnie dodatni
      estimate < 0 & ci_upper < 0 ~ "biały",          # istotnie ujemny
      ci_lower < 0 & ci_upper > 0 ~ "szary",           # nieistotny
      TRUE ~ "biały"                                   # istotny, ale z przeciwnym znakiem
    )
  )

ci_model2_2_plot <- ci_model2_2 %>%
  arrange(estimate) %>%
  mutate(
    variable = factor(variable, levels = variable),
    kolor = case_when(
      estimate > 0 & ci_lower > 0 ~ "czarny",
      estimate < 0 & ci_upper < 0 ~ "czarny",
      ci_lower < 0 & ci_upper > 0 ~ "szary",
      TRUE ~ "biały"
    )
  )

# Funkcja pomocnicza do rysowania wykresów
rysuj_wykres <- function(dane) {
  ggplot(dane, aes(x = variable, y = estimate)) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
    geom_linerange(aes(ymin = ci_lower, ymax = ci_upper), color = "black") +
    geom_point(data = subset(dane, kolor == "czarny"), color = "black", size = 3) +
    geom_point(data = subset(dane, kolor == "szary"), color = "grey50", size = 3) +
    geom_point(data = subset(dane, kolor == "biały"), fill = "white", color = "black", shape = 21, stroke = 1, size = 3) +
    labs(x = "", y = "Oszacowanie efektu stałego") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), 
          axis.title.y = element_text(margin = margin(r = 10)))
}

# Wykresy
rysuj_wykres(ci_model2_1_plot)
rysuj_wykres(ci_model2_2_plot)
