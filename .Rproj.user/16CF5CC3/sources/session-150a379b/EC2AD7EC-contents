rm(list = ls())

# --- BU KOD FAQAT NOMLARNI OLISH UCHUN BIR MARTA ISHLATILADI ---
library(httr)
library(jsonlite)
library(tidyverse)

# --- O'ZGARTIRILADIGAN QISM ---
asset_uid <- "aNaY8Pr5dLFox6Ebctkk2b"
child_table_name <- "hh_member" # XLSForm dagi takrorlanuvchi guruh nomi
# --- O'ZGARTIRILADIGAN QISM TUGADI ---

# API token'ni muhitdan o'qish
kobo_token <- Sys.getenv("KOBO_TOKEN")
if (kobo_token == "") {
  stop("API Token topilmadi! .Renviron faylini tekshiring va RStudio'ni qayta ishga tushiring.")
}

# API'dan ma'lumotlarni yuklash (ichki jadvallarni saqlagan holda)
api_url <- paste0("https://kf.kobotoolbox.org/api/v2/assets/", asset_uid, "/data.json")
response <- GET(url = api_url, add_headers(Authorization = paste("Token", kobo_token)))
stop_for_status(response, "API'dan ma'lumot olishda xatolik")

kobo_data <- fromJSON(content(response, "text", encoding = "UTF-8"), flatten = FALSE)$results

# Jadvallarni ajratish
household_raw <- kobo_data
household_raw[[child_table_name]] <- NULL
hh_members_raw <- kobo_data %>%
  select(`_uuid`, all_of(child_table_name)) %>%
  unnest(all_of(child_table_name), names_sep = "/")

# Har bir jadvalning ustun nomlarini alohida CSV fayllarga yozish
write.csv(data.frame(eski_nom = names(household_raw)), "household_nomlari.csv", row.names = FALSE)
write.csv(data.frame(eski_nom = names(hh_members_raw)), "hh_members_nomlari.csv", row.names = FALSE)

print("Nomlar muvaffaqiyatli 'household_nomlari.csv' va 'hh_members_nomlari.csv' fayllariga yozildi!")
