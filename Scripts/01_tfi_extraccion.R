
# Este script utiliza las funciones definidas en "tfi_scraping-fun.R" para recoger y almacenar
# información sobre hospedajes en las 23 provincias argentinas. 
# El input es una base de datos con las provincias, localidades y los enlaces de búsqueda en booking.
# Se dividen las provincias en regiones para mayor control del proceso de extracción.
# Al final del script estan las sentencias para extraer información de todas las provincias 

# Definimos paquetes
paquetes <- c("tidyverse", "readODS")

# Instalar si no estÃ¡n instalados
instalados <- paquetes %in% rownames(installed.packages())
if (any(instalados == FALSE)) {
  install.packages(paquetes[!instalados])
}

# Cargarlos al entorno paquetes
invisible(lapply(paquetes, library, character.only = TRUE))
rm(instalados, paquetes)

# Cargamos la funcion
source("Scripts/tfi_Scraping-fun.R")

# Cargamos un listado de enlaces
links <- read_ods("FullData/a/link_ciudades.ods", sheet = "Hoja1")

# Definimos regiones geogr?ficas y les asignamos los enlaces correspondientes
NOA <- links %>% 
  filter(Provincia == "Catamarca" | Provincia == "Jujuy" | Provincia == "Tucuman" | Provincia == "Salta" | Provincia == "Santiago Del Estero")

NEA <- links %>% 
  filter(Provincia == "Chaco" | Provincia == "Corrientes" | Provincia == "Formosa" | Provincia == "Misiones")

CUYO <- links %>% 
  filter(Provincia == "La Rioja" | Provincia == "Mendoza" | Provincia == "San Juan" | Provincia == "San Luis")

CENTRO <- links %>% 
  filter(Provincia == "Buenos Aires" | Provincia == "Entre Rios" | Provincia == "Cordoba" | Provincia == "Santa Fe")

PATAGONIA <- links %>% 
  filter(Provincia == "Chubut" | Provincia == "La Pampa" | Provincia == "Neuquen" | Provincia == "Rio Negro" | Provincia == "Santa Cruz" | Provincia == "Tierra Del Fuego")

# NOA --------------------------------------------------------------------------
# Del 1 al 15 de enero
NOA_enero_1_15 <- get_info_booking(provincia = NOA$Provincia,
                            ciudad = NOA$Ciudad,
                            links = NOA$Link,
                            n_pages = 50,
                            year = 2023,
                            month = 1,
                            dcheckin = 1,
                            dcheckout = 15)

Sys.sleep(45)

# Del 15 al 31 de enero
NOA_enero_15_31 <- get_info_booking(provincia = NOA$Provincia,
                               ciudad = NOA$Ciudad,
                               links = NOA$Link,
                               n_pages = 50,
                               year = 2023,
                               month = 1,
                               dcheckin = 15,
                               dcheckout = 31)

Sys.sleep(45)

# Almacenamos los archivos por separado
write_delim(x = NOA_enero_1_15, file = "FullData/fullFullDatabase/noa-enero-1-15.txt", delim = "\t")
write_delim(x = NOA_enero_15_31, file = "FullData/fullFullDatabase/noa-enero-15-31.txt", delim = "\t")

# Del 1 al 15 de febrero
NOA_febrero_1_15 <- get_info_booking(provincia = NOA$Provincia,
                                    ciudad = NOA$Ciudad,
                                    links = NOA$Link,
                                    n_pages = 50,
                                    year = 2023,
                                    month = 2,
                                    dcheckin = 1,
                                    dcheckout = 15)

Sys.sleep(45)

# Del 16 al 28 de febrero
NOA_febrero_15_31 <- get_info_booking(provincia = NOA$Provincia,
                                      ciudad = NOA$Ciudad,
                                      links = NOA$Link,
                                      n_pages = 50,
                                      year = 2023,
                                      month = 2,
                                      dcheckin = 15,
                                      dcheckout = 28)

write_delim(x = NOA_febrero_1_15, file = "FullData/fullFullDatabase/noa-feb-1-15.txt", delim = "\t")
write_delim(x = NOA_febrero_15_31, file = "FullData/fullFullDatabase/noa-feb-15-31.txt", delim = "\t")


Sys.sleep(45)

# Del 1 al 15 de mayo
NOA_mayo_1_15 <- get_info_booking(provincia = NOA$Provincia,
                                      ciudad = NOA$Ciudad,
                                      links = NOA$Link,
                                      n_pages = 50,
                                      year = 2023,
                                      month = 5,
                                      dcheckin = 1,
                                      dcheckout = 15)

Sys.sleep(45)

# del 16 al 31 de mayo
NOA_mayo_15_31 <- get_info_booking(provincia = NOA$Provincia,
                                      ciudad = NOA$Ciudad,
                                      links = NOA$Link,
                                      n_pages = 50,
                                      year = 2023,
                                      month = 5,
                                      dcheckin = 15,
                                      dcheckout = 31)
Sys.sleep(45)


# Del 1 al 15 de julio
NOA_julio_1_15 <- get_info_booking(provincia = NOA$Provincia,
                                  ciudad = NOA$Ciudad,
                                  links = NOA$Link,
                                  n_pages = 50,
                                  year = 2023,
                                  month = 7,
                                  dcheckin = 1,
                                  dcheckout = 15)

write_delim(x = NOA_mayo_1_15, file = "FullData/fullFullDatabase/noa-may-1-15.txt", delim = "\t")
write_delim(x = NOA_mayo_15_31, file = "FullData/fullFullDatabase/noa-may-15-31.txt", delim = "\t")
write_delim(x = NOA_julio_1_15, file = "FullData/fullFullDatabase/noa-jul-1-15.txt", delim = "\t")



Sys.sleep(45)

# Del 16 al 31 de julio
NOA_julio_15_31 <- get_info_booking(provincia = NOA$Provincia,
                                   ciudad = NOA$Ciudad,
                                   links = NOA$Link,
                                   n_pages = 50,
                                   year = 2023,
                                   month = 5,
                                   dcheckin = 15,
                                   dcheckout = 31)

Sys.sleep(45)

# Del 1 al 15 de octubre
NOA_octubre_1_15 <- get_info_booking(provincia = NOA$Provincia,
                                   ciudad = NOA$Ciudad,
                                   links = NOA$Link,
                                   n_pages = 50,
                                   year = 2023,
                                   month = 10,
                                   dcheckin = 1,
                                   dcheckout = 15)

Sys.sleep(45)

# Del 16 al 31 de octubre
NOA_octubre_15_31 <- get_info_booking(provincia = NOA$Provincia,
                                     ciudad = NOA$Ciudad,
                                     links = NOA$Link,
                                     n_pages = 50,
                                     year = 2023,
                                     month = 10,
                                     dcheckin = 15,
                                     dcheckout = 31)
Sys.sleep(45)

write_delim(x = NOA_julio_15_31, file = "FullData/fullFullDatabase/noa-jul-15-31.txt", delim = "\t")
write_delim(x = NOA_octubre_1_15, file = "FullData/fullFullDatabase/noa-oct-1-15.txt", delim = "\t")
write_delim(x = NOA_octubre_15_31, file = "FullData/fullFullDatabase/noa-oct-15-31.txt", delim = "\t")



# NEA --------------------------------------------------------------------------
# Del 1 al 15 de enero
NEA_enero_1_15 <- get_info_booking(provincia = NEA$Provincia,
                                   ciudad = NEA$Ciudad,
                                   links = NEA$Link,
                                   n_pages = 50,
                                   year = 2023,
                                   month = 1,
                                   dcheckin = 1,
                                   dcheckout = 15)

write_delim(x = NEA_enero_1_15, file = "FullData/fullFullDatabase/nea-ene-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 15 al 31 de enero
NEA_enero_15_31 <- get_info_booking(provincia = NEA$Provincia,
                                    ciudad = NEA$Ciudad,
                                    links = NEA$Link,
                                    n_pages = 50,
                                    year = 2023,
                                    month = 1,
                                    dcheckin = 15,
                                    dcheckout = 31)
write_delim(x = NEA_enero_15_31, file = "FullData/fullFullDatabase/nea-ene-15-31.txt", delim = "\t")

# Del 1 al 15 de febrero
NEA_febrero_1_15 <- get_info_booking(provincia = NEA$Provincia,
                                      ciudad = NEA$Ciudad,
                                      links = NEA$Link,
                                      n_pages = 50,
                                      year = 2023,
                                      month = 2,
                                      dcheckin = 1,
                                      dcheckout = 15)
write_delim(x = NEA_febrero_1_15, file = "FullData/fullFullDatabase/nea-feb-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 16 al 28 de febrero
NEA_febrero_15_31 <- get_info_booking(provincia = NEA$Provincia,
                                      ciudad = NEA$Ciudad,
                                      links = NEA$Link,
                                      n_pages = 50,
                                      year = 2023,
                                      month = 2,
                                      dcheckin = 15,
                                      dcheckout = 28)

write_delim(x = NEA_febrero_15_31, file = "FullData/fullFullDatabase/nea-feb-15-31.txt", delim = "\t")

Sys.sleep(45)

# Del 1 al 15 de mayo
NEA_mayo_1_15 <- get_info_booking(provincia = NEA$Provincia,
                                  ciudad = NEA$Ciudad,
                                  links = NEA$Link,
                                  n_pages = 50,
                                  year = 2023,
                                  month = 5,
                                  dcheckin = 1,
                                  dcheckout = 15)
write_delim(x = NEA_mayo_1_15, file = "FullData/fullFullDatabase/nea-may-1-15.txt", delim = "\t")

Sys.sleep(45)

# del 16 al 31 de mayo
NEA_mayo_15_31 <- get_info_booking(provincia = NEA$Provincia,
                                   ciudad = NEA$Ciudad,
                                   links = NEA$Link,
                                   n_pages = 50,
                                   year = 2023,
                                   month = 5,
                                   dcheckin = 15,
                                   dcheckout = 31)
write_delim(x = NEA_mayo_15_31, file = "FullData/fullFullDatabase/nea-may-15-31.txt", delim = "\t")


# Del 1 al 15 de julio
NEA_julio_1_15 <- get_info_booking(provincia = NEA$Provincia,
                                   ciudad = NEA$Ciudad,
                                   links = NEA$Link,
                                   n_pages = 50,
                                   year = 2023,
                                   month = 7,
                                   dcheckin = 1,
                                   dcheckout = 15)
write_delim(x = NEA_julio_1_15, file = "FullData/fullFullDatabase/nea-jul-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 16 al 31 de julio
NEA_julio_15_31 <- get_info_booking(provincia = NEA$Provincia,
                                    ciudad = NEA$Ciudad,
                                    links = NEA$Link,
                                    n_pages = 50,
                                    year = 2023,
                                    month = 7,
                                    dcheckin = 15,
                                    dcheckout = 31)
write_delim(x = NEA_julio_15_31, file = "FullData/fullFullDatabase/nea-jul-15-31.txt", delim = "\t")


# Del 1 al 15 de octubre
NEA_octubre_1_15 <- get_info_booking(provincia = NEA$Provincia,
                                     ciudad = NEA$Ciudad,
                                     links = NEA$Link,
                                     n_pages = 50,
                                     year = 2023,
                                     month = 10,
                                     dcheckin = 1,
                                     dcheckout = 15)
write_delim(x = NEA_octubre_1_15, file = "FullData/fullFullDatabase/nea-oct-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 16 al 31 de octubre
NEA_octubre_15_31 <- get_info_booking(provincia = NEA$Provincia,
                                      ciudad = NEA$Ciudad,
                                      links = NEA$Link,
                                      n_pages = 50,
                                      year = 2023,
                                      month = 10,
                                      dcheckin = 15,
                                      dcheckout = 31)
write_delim(x = NEA_octubre_15_31, file = "FullData/fullFullDatabase/nea-oct-15-31.txt", delim = "\t")
Sys.sleep(45)








# CUYO --------------------------------------------------------------------------
# Del 1 al 15 de enero
CUYO_enero_1_15 <- get_info_booking(provincia = CUYO$Provincia,
                                   ciudad = CUYO$Ciudad,
                                   links = CUYO$Link,
                                   n_pages = 50,
                                   year = 2023,
                                   month = 1,
                                   dcheckin = 1,
                                   dcheckout = 15)

write_delim(x = CUYO_enero_1_15, file = "FullData/fullFullDatabase/CUYO-ene-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 15 al 31 de enero
CUYO_enero_15_31 <- get_info_booking(provincia = CUYO$Provincia,
                                    ciudad = CUYO$Ciudad,
                                    links = CUYO$Link,
                                    n_pages = 50,
                                    year = 2023,
                                    month = 1,
                                    dcheckin = 15,
                                    dcheckout = 31)
write_delim(x = CUYO_enero_15_31, file = "FullData/fullFullDatabase/CUYO-ene-15-31.txt", delim = "\t")

# Del 1 al 15 de febrero
CUYO_febrero_1_15 <- get_info_booking(provincia = CUYO$Provincia,
                                     ciudad = CUYO$Ciudad,
                                     links = CUYO$Link,
                                     n_pages = 50,
                                     year = 2023,
                                     month = 2,
                                     dcheckin = 1,
                                     dcheckout = 15)
write_delim(x = CUYO_febrero_1_15, file = "FullData/fullFullDatabase/CUYO-feb-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 16 al 28 de febrero
CUYO_febrero_15_31 <- get_info_booking(provincia = CUYO$Provincia,
                                      ciudad = CUYO$Ciudad,
                                      links = CUYO$Link,
                                      n_pages = 50,
                                      year = 2023,
                                      month = 2,
                                      dcheckin = 15,
                                      dcheckout = 28)

write_delim(x = CUYO_febrero_15_31, file = "FullData/fullFullDatabase/CUYO-feb-15-31.txt", delim = "\t")

Sys.sleep(45)

# Del 1 al 15 de mayo
CUYO_mayo_1_15 <- get_info_booking(provincia = CUYO$Provincia,
                                  ciudad = CUYO$Ciudad,
                                  links = CUYO$Link,
                                  n_pages = 50,
                                  year = 2023,
                                  month = 5,
                                  dcheckin = 1,
                                  dcheckout = 15)
write_delim(x = CUYO_mayo_1_15, file = "FullData/fullFullDatabase/CUYO-may-1-15.txt", delim = "\t")

Sys.sleep(45)

# del 16 al 31 de mayo
CUYO_mayo_15_31 <- get_info_booking(provincia = CUYO$Provincia,
                                   ciudad = CUYO$Ciudad,
                                   links = CUYO$Link,
                                   n_pages = 50,
                                   year = 2023,
                                   month = 5,
                                   dcheckin = 15,
                                   dcheckout = 31)
write_delim(x = CUYO_mayo_15_31, file = "FullData/fullFullDatabase/CUYO-may-15-31.txt", delim = "\t")


# Del 1 al 15 de julio
CUYO_julio_1_15 <- get_info_booking(provincia = CUYO$Provincia,
                                   ciudad = CUYO$Ciudad,
                                   links = CUYO$Link,
                                   n_pages = 50,
                                   year = 2023,
                                   month = 7,
                                   dcheckin = 1,
                                   dcheckout = 15)
write_delim(x = CUYO_julio_1_15, file = "FullData/fullFullDatabase/CUYO-jul-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 16 al 31 de julio
CUYO_julio_15_31 <- get_info_booking(provincia = CUYO$Provincia,
                                    ciudad = CUYO$Ciudad,
                                    links = CUYO$Link,
                                    n_pages = 50,
                                    year = 2023,
                                    month = 7,
                                    dcheckin = 15,
                                    dcheckout = 31)
write_delim(x = CUYO_julio_15_31, file = "FullData/fullFullDatabase/CUYO-jul-15-31.txt", delim = "\t")


# Del 1 al 15 de octubre
CUYO_octubre_1_15 <- get_info_booking(provincia = CUYO$Provincia,
                                     ciudad = CUYO$Ciudad,
                                     links = CUYO$Link,
                                     n_pages = 50,
                                     year = 2023,
                                     month = 10,
                                     dcheckin = 1,
                                     dcheckout = 15)
write_delim(x = CUYO_octubre_1_15, file = "FullData/fullFullDatabase/CUYO-oct-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 16 al 31 de octubre
CUYO_octubre_15_31 <- get_info_booking(provincia = CUYO$Provincia,
                                      ciudad = CUYO$Ciudad,
                                      links = CUYO$Link,
                                      n_pages = 50,
                                      year = 2023,
                                      month = 10,
                                      dcheckin = 15,
                                      dcheckout = 31)
write_delim(x = CUYO_octubre_15_31, file = "FullData/fullFullDatabase/CUYO-oct-15-31.txt", delim = "\t")
Sys.sleep(45)

# CENTRO --------------------------------------------------------------------------
# Del 1 al 15 de enero
CENTRO_enero_1_15 <- get_info_booking(provincia = CENTRO$Provincia,
                                   ciudad = CENTRO$Ciudad,
                                   links = CENTRO$Link,
                                   n_pages = 50,
                                   year = 2023,
                                   month = 1,
                                   dcheckin = 1,
                                   dcheckout = 15)

write_delim(x = CENTRO_enero_1_15, file = "FullData/fullFullDatabase/CENTRO-ene-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 15 al 31 de enero
CENTRO_enero_15_31 <- get_info_booking(provincia = CENTRO$Provincia,
                                    ciudad = CENTRO$Ciudad,
                                    links = CENTRO$Link,
                                    n_pages = 50,
                                    year = 2023,
                                    month = 1,
                                    dcheckin = 15,
                                    dcheckout = 31)
write_delim(x = CENTRO_enero_15_31, file = "FullData/fullFullDatabase/CENTRO-ene-15-31.txt", delim = "\t")

# Del 1 al 15 de febrero
CENTRO_febrero_1_15 <- get_info_booking(provincia = CENTRO$Provincia,
                                     ciudad = CENTRO$Ciudad,
                                     links = CENTRO$Link,
                                     n_pages = 50,
                                     year = 2023,
                                     month = 2,
                                     dcheckin = 1,
                                     dcheckout = 15)
write_delim(x = CENTRO_febrero_1_15, file = "FullData/fullFullDatabase/CENTRO-feb-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 16 al 28 de febrero
CENTRO_febrero_15_31 <- get_info_booking(provincia = CENTRO$Provincia,
                                      ciudad = CENTRO$Ciudad,
                                      links = CENTRO$Link,
                                      n_pages = 50,
                                      year = 2023,
                                      month = 2,
                                      dcheckin = 15,
                                      dcheckout = 28)

write_delim(x = CENTRO_febrero_15_31, file = "FullData/fullFullDatabase/CENTRO-feb-15-31.txt", delim = "\t")

Sys.sleep(240)

# Del 1 al 15 de mayo
CENTRO_mayo_1_15 <- get_info_booking(provincia = CENTRO$Provincia,
                                  ciudad = CENTRO$Ciudad,
                                  links = CENTRO$Link,
                                  n_pages = 50,
                                  year = 2023,
                                  month = 5,
                                  dcheckin = 1,
                                  dcheckout = 15)

write_delim(x = CENTRO_mayo_1_15, file = "FullData/fullFullDatabase/CENTRO-may-1-15.txt", delim = "\t")

Sys.sleep(45)

# del 16 al 31 de mayo
CENTRO_mayo_15_31 <- get_info_booking(provincia = CENTRO$Provincia,
                                   ciudad = CENTRO$Ciudad,
                                   links = CENTRO$Link,
                                   n_pages = 50,
                                   year = 2023,
                                   month = 5,
                                   dcheckin = 15,
                                   dcheckout = 31)
write_delim(x = CENTRO_mayo_15_31, file = "FullData/fullFullDatabase/CENTRO-may-15-31.txt", delim = "\t")


# Del 1 al 15 de julio
CENTRO_julio_1_15 <- get_info_booking(provincia = CENTRO$Provincia,
                                   ciudad = CENTRO$Ciudad,
                                   links = CENTRO$Link,
                                   n_pages = 50,
                                   year = 2023,
                                   month = 7,
                                   dcheckin = 1,
                                   dcheckout = 15)
write_delim(x = CENTRO_julio_1_15, file = "FullData/fullFullDatabase/CENTRO-jul-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 16 al 31 de julio
CENTRO_julio_15_31 <- get_info_booking(provincia = CENTRO$Provincia,
                                    ciudad = CENTRO$Ciudad,
                                    links = CENTRO$Link,
                                    n_pages = 50,
                                    year = 2023,
                                    month = 7,
                                    dcheckin = 15,
                                    dcheckout = 31)
write_delim(x = CENTRO_julio_15_31, file = "FullData/fullFullDatabase/CENTRO-jul-15-31.txt", delim = "\t")


# Del 1 al 15 de octubre
CENTRO_octubre_1_15 <- get_info_booking(provincia = CENTRO$Provincia,
                                     ciudad = CENTRO$Ciudad,
                                     links = CENTRO$Link,
                                     n_pages = 50,
                                     year = 2023,
                                     month = 10,
                                     dcheckin = 1,
                                     dcheckout = 15)
write_delim(x = CENTRO_octubre_1_15, file = "FullData/fullFullDatabase/CENTRO-oct-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 16 al 31 de octubre
CENTRO_octubre_15_31 <- get_info_booking(provincia = CENTRO$Provincia,
                                      ciudad = CENTRO$Ciudad,
                                      links = CENTRO$Link,
                                      n_pages = 50,
                                      year = 2023,
                                      month = 10,
                                      dcheckin = 15,
                                      dcheckout = 31)
write_delim(x = CENTRO_octubre_15_31, file = "FullData/fullFullDatabase/CENTRO-oct-15-31.txt", delim = "\t")
Sys.sleep(45)

# PATAGONIA --------------------------------------------------------------------------
# Del 1 al 15 de enero
PATAGONIA_enero_1_15 <- get_info_booking(provincia = PATAGONIA$Provincia,
                                   ciudad = PATAGONIA$Ciudad,
                                   links = PATAGONIA$Link,
                                   n_pages = 50,
                                   year = 2023,
                                   month = 1,
                                   dcheckin = 1,
                                   dcheckout = 15)

write_delim(x = PATAGONIA_enero_1_15, file = "FullData/fullFullDatabase/PATAGONIA-ene-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 15 al 31 de enero
PATAGONIA_enero_15_31 <- get_info_booking(provincia = PATAGONIA$Provincia,
                                    ciudad = PATAGONIA$Ciudad,
                                    links = PATAGONIA$Link,
                                    n_pages = 50,
                                    year = 2023,
                                    month = 1,
                                    dcheckin = 15,
                                    dcheckout = 31)
write_delim(x = PATAGONIA_enero_15_31, file = "FullData/fullFullDatabase/PATAGONIA-ene-15-31.txt", delim = "\t")

Sys.sleep(45)

# Del 1 al 15 de febrero
PATAGONIA_febrero_1_15 <- get_info_booking(provincia = PATAGONIA$Provincia,
                                     ciudad = PATAGONIA$Ciudad,
                                     links = PATAGONIA$Link,
                                     n_pages = 50,
                                     year = 2023,
                                     month = 2,
                                     dcheckin = 1,
                                     dcheckout = 15)
write_delim(x = PATAGONIA_febrero_1_15, file = "FullData/fullFullDatabase/PATAGONIA-feb-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 16 al 28 de febrero
PATAGONIA_febrero_15_31 <- get_info_booking(provincia = PATAGONIA$Provincia,
                                      ciudad = PATAGONIA$Ciudad,
                                      links = PATAGONIA$Link,
                                      n_pages = 50,
                                      year = 2023,
                                      month = 2,
                                      dcheckin = 15,
                                      dcheckout = 28)

write_delim(x = PATAGONIA_febrero_15_31, file = "FullData/fullFullDatabase/PATAGONIA-feb-15-31.txt", delim = "\t")

Sys.sleep(45)

# Del 1 al 15 de mayo
PATAGONIA_mayo_1_15 <- get_info_booking(provincia = PATAGONIA$Provincia,
                                  ciudad = PATAGONIA$Ciudad,
                                  links = PATAGONIA$Link,
                                  n_pages = 50,
                                  year = 2023,
                                  month = 5,
                                  dcheckin = 1,
                                  dcheckout = 15)
write_delim(x = PATAGONIA_mayo_1_15, file = "FullData/fullFullDatabase/PATAGONIA-may-1-15.txt", delim = "\t")

Sys.sleep(45)

# del 16 al 31 de mayo
PATAGONIA_mayo_15_31 <- get_info_booking(provincia = PATAGONIA$Provincia,
                                   ciudad = PATAGONIA$Ciudad,
                                   links = PATAGONIA$Link,
                                   n_pages = 50,
                                   year = 2023,
                                   month = 5,
                                   dcheckin = 15,
                                   dcheckout = 31)
write_delim(x = PATAGONIA_mayo_15_31, file = "FullData/fullFullDatabase/PATAGONIA-may-15-31.txt", delim = "\t")


# Del 1 al 15 de julio
PATAGONIA_julio_1_15 <- get_info_booking(provincia = PATAGONIA$Provincia,
                                   ciudad = PATAGONIA$Ciudad,
                                   links = PATAGONIA$Link,
                                   n_pages = 50,
                                   year = 2023,
                                   month = 7,
                                   dcheckin = 1,
                                   dcheckout = 15)
write_delim(x = PATAGONIA_julio_1_15, file = "FullData/fullFullDatabase/PATAGONIA-jul-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 16 al 31 de julio
PATAGONIA_julio_15_31 <- get_info_booking(provincia = PATAGONIA$Provincia,
                                    ciudad = PATAGONIA$Ciudad,
                                    links = PATAGONIA$Link,
                                    n_pages = 50,
                                    year = 2023,
                                    month = 7,
                                    dcheckin = 15,
                                    dcheckout = 31)
write_delim(x = PATAGONIA_julio_15_31, file = "FullData/fullFullDatabase/PATAGONIA-jul-15-31.txt", delim = "\t")


# Del 1 al 15 de octubre
PATAGONIA_octubre_1_15 <- get_info_booking(provincia = PATAGONIA$Provincia,
                                     ciudad = PATAGONIA$Ciudad,
                                     links = PATAGONIA$Link,
                                     n_pages = 50,
                                     year = 2023,
                                     month = 10,
                                     dcheckin = 1,
                                     dcheckout = 15)
write_delim(x = PATAGONIA_octubre_1_15, file = "FullData/fullFullDatabase/PATAGONIA-oct-1-15.txt", delim = "\t")

Sys.sleep(45)

# Del 16 al 31 de octubre
PATAGONIA_octubre_15_31 <- get_info_booking(provincia = PATAGONIA$Provincia,
                                      ciudad = PATAGONIA$Ciudad,
                                      links = PATAGONIA$Link,
                                      n_pages = 50,
                                      year = 2023,
                                      month = 10,
                                      dcheckin = 15,
                                      dcheckout = 31)
write_delim(x = PATAGONIA_octubre_15_31, file = "FullData/fullFullDatabase/PATAGONIA-oct-15-31.txt", delim = "\t")



# Codigo que extrae, para todas las provincias, información de alquileres para el mes de marzo.

marzo_q1 <- get_info_booking(provincia = links$Provincia,
                                ciudad = links$Ciudad,
                                links = links$Link,
                                n_pages = 50,
                                year = 2023,
                                month = 3,
                                dcheckin = 1,
                                dcheckout = 15)

write_delim(x = marzo_q1, file = "FullData/fullFullDatabase/marzo_q1.txt", delim = "\t")

marzo_q2 <- get_info_booking(provincia = links$Provincia,
                             ciudad = links$Ciudad,
                             links = links$Link,
                             n_pages = 50,
                             year = 2023,
                             month = 3,
                             dcheckin = 15,
                             dcheckout = 31)
write_delim(x = marzo_q2, file = "FullData/fullFullDatabase/marzo_q2.txt", delim = "\t")

abril_q1 <- get_info_booking(provincia = links$Provincia,
                             ciudad = links$Ciudad,
                             links = links$Link,
                             n_pages = 50,
                             year = 2023,
                             month = 4,
                             dcheckin = 1,
                             dcheckout = 15)

write_delim(x = abril_q1, file = "FullData/fullFullDatabase/abril_q1.txt", delim = "\t")

abril_q2<- get_info_booking(provincia = links$Provincia,
                            ciudad = links$Ciudad,
                            links = links$Link,
                            n_pages = 50,
                            year = 2023,
                            month = 4,
                            dcheckin = 15,
                            dcheckout = 30)
write_delim(x = abril_q2, file = "FullData/fullFullDatabase/abril_q2.txt", delim = "\t")


junio_q1<- get_info_booking(provincia = links$Provincia,
                            ciudad = links$Ciudad,
                            links = links$Link,
                            n_pages = 50,
                            year = 2023,
                            month = 6,
                            dcheckin = 1,
                            dcheckout = 15)
write_delim(x = junio_q1, file = "FullData/fullFullDatabase/junio_q1.txt", delim = "\t")


junio_q2<- get_info_booking(provincia = links$Provincia,
                            ciudad = links$Ciudad,
                            links = links$Link,
                            n_pages = 50,
                            year = 2023,
                            month = 6,
                            dcheckin = 15,
                            dcheckout = 30)
write_delim(x = junio_q2, file = "FullData/fullFullDatabase/junio_q2.txt", delim = "\t")


agosto_q1<- get_info_booking(provincia = links$Provincia,
                             ciudad = links$Ciudad,
                             links = links$Link,
                             n_pages = 50,
                             year = 2023,
                             month = 8,
                             dcheckin = 1,
                             dcheckout = 15)

write_delim(x = agosto_q1, file = "FullData/fullFullDatabase/agosto_q1.txt", delim = "\t")

agosto_q2<- get_info_booking(provincia = links$Provincia,
                             ciudad = links$Ciudad,
                             links = links$Link,
                             n_pages = 50,
                             year = 2023,
                             month = 8,
                             dcheckin = 15,
                             dcheckout = 31)

write_delim(x = agosto_q2, file = "FullData/fullFullDatabase/agosto_q2.txt", delim = "\t")

septiembre_q1<- get_info_booking(provincia = links$Provincia,
                                 ciudad = links$Ciudad,
                                 links = links$Link,
                                 n_pages = 50,
                                 year = 2023,
                                 month = 9,
                                 dcheckin = 1,
                                 dcheckout = 15)

write_delim(x = septiembre_q1, file = "FullData/fullFullDatabase/septiembre_q1.txt", delim = "\t")

septiembre_q2<- get_info_booking(provincia = links$Provincia,
                                 ciudad = links$Ciudad,
                                 links = links$Link,
                                 n_pages = 50,
                                 year = 2023,
                                 month = 9,
                                 dcheckin = 15,
                                 dcheckout = 30)

write_delim(x = septiembre_q2, file = "FullData/fullFullDatabase/septiembre_q2.txt", delim = "\t")

noviembre_q1<- get_info_booking(provincia = links$Provincia,
                                ciudad = links$Ciudad,
                                links = links$Link,
                                n_pages = 50,
                                year = 2023,
                                month = 11,
                                dcheckin = 1,
                                dcheckout = 15)

write_delim(x = noviembre_q1, file = "FullData/fullFullDatabase/noviembre_q1.txt", delim = "\t")

noviembre_q2<- get_info_booking(provincia = links$Provincia,
                                ciudad = links$Ciudad,
                                links = links$Link,
                                n_pages = 50,
                                year = 2023,
                                month = 11,
                                dcheckin = 15,
                                dcheckout = 30)

write_delim(x = noviembre_q2, file = "FullData/fullFullDatabase/noviembre_q2.txt", delim = "\t")

diciembre_q1<- get_info_booking(provincia = links$Provincia,
                                ciudad = links$Ciudad,
                                links = links$Link,
                                n_pages = 50,
                                year = 2023,
                                month = 12,
                                dcheckin = 1,
                                dcheckout = 15)

write_delim(x = diciembre_q1, file = "FullData/fullFullDatabase/diciembre_q1.txt", delim = "\t")

diciembre_q2<- get_info_booking(provincia = links$Provincia,
                                ciudad = links$Ciudad,
                                links = links$Link,
                                n_pages = 50,
                                year = 2023,
                                month = 12,
                                dcheckin = 15,
                                dcheckout = 31)

write_delim(x = diciembre_q2, file = "FullData/fullFullDatabase/diciembre_q2.txt", delim = "\t")

