# ===================================================================
#             YANGILANGAN `update_report.R` SKRIPTI
# ===================================================================

# 1. KERAKLI PAKETLARNI YUKLASH
# -------------------------------------------------------------------
# Bu skript uchun faqat shu paketlar kerak.
# `tidyverse` bu yerda shart emas, chunki faqat ma'lumot yuklanadi.
library(httr)
library(jsonlite)
library(quarto)

# 2. LOYIHA SOZLAMALARI
# -------------------------------------------------------------------
# Bu ma'lumotlar sizning `report.qmd` faylingizdan olindi.
asset_uid <- "aNaY8Pr5dLFox6Ebctkk2b"
kobo_server_url <- "https://kf.kobotoolbox.org" # Sizning serveringiz

# 3. API TOKENNI XAVFSIZ OLISH
# -------------------------------------------------------------------
# GitHub Secrets'dagi o'zgaruvchi nomi siz ko'rsatgandek "KOBO_TOKEN" bo'lishi kerak.
kobo_token <- Sys.getenv("KOBO_TOKEN")

if (kobo_token == "") {
  stop("Xatolik: KOBO_TOKEN topilmadi! GitHub Secrets'ga to'g'ri nom bilan qo'shganingizni tekshiring.")
}

# 4. API'DAN JSON MA'LUMOTLARNI YUKLASH
# -------------------------------------------------------------------
# JSON endpoint manzilini yaratish
api_url <- paste0(kobo_server_url, "/api/v2/assets/", asset_uid, "/data.json")

cat("API'ga so'rov yuborilmoqda:", api_url, "\n")

# GET so'rovini yuborish
response <- GET(
  url = api_url,
  add_headers(Authorization = paste("Token", kobo_token))
)

# Xatoliklarni tekshirish
stop_for_status(response, task = "KoboToolbox'dan JSON ma'lumot yuklash")

# JSON ma'lumotini R ro'yxatiga (list) aylantirish
# `flatten = FALSE` takrorlanuvchi guruhlar strukturasini saqlab qoladi.
kobo_data_list <- fromJSON(content(response, "text", encoding = "UTF-8"), flatten = FALSE)

# Asosiy ma'lumotlarni ajratib olish
kobo_data <- kobo_data_list$results

cat("Ma'lumotlar muvaffaqiyatli yuklandi!\n")

# 5. MA'LUMOTLARNI .RDS FAYLIGA SAQLASH
# -------------------------------------------------------------------
# .rds formati R dagi murakkab obyektlarni (list, data.frame) saqlash uchun ideal.
saveRDS(kobo_data, file = "kobo_data.rds")

cat("Ma'lumotlar 'kobo_data.rds' fayliga muvaffaqiyatli saqlandi.\n")

# 6. QUARTO HUJJATINI RENDER QILISH
# -------------------------------------------------------------------
quarto_render("report.qmd")

cat("Hisobot muvaffaqiyatli yangilandi! ✅\n")