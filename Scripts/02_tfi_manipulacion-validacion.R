# En este script se importan los datos extraídos de Booking y se procesan para 
# luego, exponer la informaciÃ³n en los mapas y tablas correspondientes. En 
# primer lugar se realizan las transformaciones necesarias para tener los datos 
# en el formato correspondiente. Luego, se eliminan las filas duplicadas, se 
# analizan y se tratan los valores nulos.

# Definimos paquetes
paquetes <- c("tidyverse", "lubridate", "naniar", "zoo", "janitor", 
              "haven", "univariateML", "rgdal", "sf", "sp")

# Instalar si no estan instalados
instalados <- paquetes %in% rownames(installed.packages())
if (any(instalados == FALSE)) {
  install.packages(paquetes[!instalados])
}

# Cargarlos al entorno paquetes
invisible(lapply(paquetes, library, character.only = TRUE))
rm(instalados, paquetes)

# Evaluo el encoding del archivo
guess_encoding("Data/fulldatabase/CENTRO-ene-1-15.txt")

# Cargo los archivos individuales (esto es necesario solo si se realiza la extraccion por partes)
files <-list.files(path = "Data/fulldatabase", pattern = NULL, all.files = FALSE,
                              full.names = FALSE, recursive = FALSE,
                              ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)

data <- NULL

for(i in 1:length(files)){
  path <- paste0("Data/fulldatabase/", files[i])
  data <- bind_rows(data, read.delim(path, sep = "\t", encoding = "UTF-8"))
}

# Limpiamos los datos, principalmente los numericos ----------------------------
# Eliminamos tildes y cambiamos mayusculas por minusculas
data$titulo <- tolower(data$titulo)
data$titulo <- chartr("áéíóúÁÉÍÓÚàèìòùÀÈÌÒÙü", "aeiouAEIOUaeiouAEIOUu", x = data$titulo)
data$descripcion <- tolower(data$descripcion)
data$descripcion <- chartr("áéíóúàèìòùü", "aeiouaeiouu", x = data$descripcion)
data$localizacion <- chartr("áéíóúÁÉÍÓÚàèìòùÀÈÌÒÙü", "aeiouAEIOUaeiouAEIOUu", x = data$localizacion)

# Reemplazamos la coma por el punto y convertimos en numerico
data$calif <- gsub(pattern = "\\,", replacement = "\\.", data$calif)
data$calif <- as.numeric(data$calif)

# Dejamos solo la ùltima palabra, reemplazamos caracteres y convetimos en numericos
data$precio <- word(data$precio, -1)
data$precio <- str_replace_all(data$precio, c("\\$" = "", "\\." = ""))
data$precio <- substr(data$precio, 2, nchar(data$precio))
data$precio <- as.numeric(data$precio)
data$precio %>% head()

# Realizamos el mismo procedimiento con los impuestos (si hay, sino impuesto == 0). 
data$impuesto <- ifelse(str_detect(data$impuesto, "Incluye") == TRUE,
                        "00",
                        word(data$impuesto, 2))
data$impuesto <- str_replace_all(data$impuesto,
                                 c("\\." = "", 
                                   "\\$" = ""))
data$impuesto <- substr(data$impuesto, 2, nchar(data$impuesto))
data$impuesto <- as.numeric(data$impuesto)
data$impuesto %>% head()
is.null(data$impuesto)

# Se reemplazan los nulos por 0 para que no impacten en el valor bruto
data$impuesto <- ifelse(is.na(data$impuesto), 0, data$impuesto)

# Limpiamos la columna noche
data$noches <- word(data$noches)
data$noches <- as.numeric(data$noches)
unique(data$noches)

# Podemos observar que hay valores nulos en noches. Los reemplazaremos en funciÃ³n de las fechasa
# de check in y check out
data <- data %>% 
  mutate(noches = day(checkout) - day(checkin))

# Convertimos las categorias en factores y transformamos las fechas para extraer los meses y las quincenas.
data$localizacion <- as.character(data$localizacion)

data$provincia <- gsub(pattern = "Santiago Del Estero", replacement = "Santiago del Estero", data$provincia)
data$provincia <- gsub(pattern = "Tierra Del Fuego", replacement = "Tierra del Fuego", data$provincia)
data$provincia <- as.factor(data$provincia)

data$checkin <- ymd(data$checkin)
data$checkout <- ymd(data$checkout)
data["mes"] <- month(data$checkin)
data["quincena"] <- ifelse(day(data$checkin) < 15, "primera quincena", "segunda quincena")

head(data)

# Calculamos el precio bruto por noche 
data <- data %>% 
  mutate(precio_noche = precio / noches,
         impuesto_noche = impuesto / noches,
         bruto_noche = precio_noche + ifelse(!is.na(impuesto_noche), impuesto_noche, 0))

### Duplicados -----------------------------------------------------------------
# Nos quedamos con las columnas que nos interesan
data <- data %>% 
  select(provincia, localizacion, titulo, descripcion, calif, precio_noche, impuesto_noche, bruto_noche, mes)

# Evaluamos y eliminamos aquellos registros que sean iguales en todas las filas. 
data %>%  
  duplicated() %>% 
  table()

data <- data %>% 
  distinct()

### Valores Nulos --------------------------------------------------------------
# Observamos los valores nulos en general y por categoria 
miss_var_summary(data)

data %>% 
  group_by(provincia) %>%
  select(calif, impuesto_noche, bruto_noche, precio_noche) %>% 
  miss_var_summary() %>% 
  filter(n_miss > 0) %>% 
  arrange(variable) %>% 
  print(n = 32) 

data %>% 
  select(-calif) %>% 
  gg_miss_fct(fct = provincia)+
  labs(x = "month", y = "provincia", title = "Na's por provincia")

# En todas las provincias faltan calif.
# En Buenos Aires falta precio.
data %>% 
  filter(provincia == "Buenos Aires") %>% 
  group_by(localizacion) %>% 
  select(bruto_noche) %>% 
  miss_var_summary() %>% 
  print(n = 105)

data %>% 
  filter(provincia == "Misiones") %>% 
  group_by(localizacion) %>% 
  select(bruto_noche) %>% 
  miss_var_summary() %>% 
  print(n = 105)

# Los valores faltantes de precio son sistematicos, y corresponden al factor "Delta del tigre".
# Se eliminará esa localizacion del set de datos, ya que estÃ¡ duplicada bajo el factor "Tigre"
# Con respecto a la provincia de misiones, se eliminará solo el valor nulo.

data <- data %>% 
  filter(!is.na(bruto_noche))

# Por ultimo, para los valores nulos de calificacion se modelara la distribucion 
# de probabilidad y se rellenaran con valores aleatorios, distribu?dos de forma similar.
data_na <- data %>% 
  filter(!is.na(calif) & calif > 1) %>% 
  mutate(calif = calif)

# Utilizamos el criterio de informaciÃ³n bayesiano para obtener informaciÃ³n sobre la distribuciÃ³n de la calificaciÃ³n.
BIC(
  mlexp(data_na$calif),
  mlinvgamma(data_na$calif),
  mlgamma(data_na$calif),
  mllnorm(data_na$calif),
  mlrayleigh(data_na$calif),
  mlinvgauss(data_na$calif),
  mlweibull(data_na$calif),
  mlinvweibull(data_na$calif),
  mllgamma(data_na$calif)
) %>% 
  arrange(-desc(BIC))

ggplot(data = data) +
  geom_histogram(aes(x = calif, y =  after_stat(density)),
                 bins = 30, color = "black", fill ="orange") +
  geom_rug(aes(x = calif)) +
  stat_function(fun = function(.x){dml(x = .x, obj = mlweibull(data_na$calif))},
                aes(color = "Weibull"),
                size = 1) +
  stat_function(fun = function(.x){dml(x = .x, obj = mlbetapr(data_na$calif))},
                aes(color = "betapr"),
                size = 1) +
  scale_color_manual(breaks = c("Weibull", "betapr"),
                     values = c("Weibull" = "red", "betapr" = "blue")) +
  labs(title = "Distribuciónn de Calificacion",
       color = "Distribución") +
  theme_bw() +
  theme(legend.position = "bottom")

distribucion <- mlweibull(x = data_na$calif)
summary(distribucion)

calif <- data$calif


# Rellenamos los faltantes con valores aleatorios de una distribuciÃ³n similar

repeat{
  
  minv <- min(calif)
  maxv <- max(calif)
  
  if (minv > 0 & maxv <= 10 & any_na(calif) == FALSE) {
    break
  }
  
  for (i in 1:length(calif) ) {
    novalid <- NULL
    novalid <- ifelse(calif[i] > 10 || is.na(calif[i]), 1, 0)
    
    if (novalid == 1) {
      calif[i] <- rweibull(n = 1, shape = distribucion[[1]], scale = distribucion[[2]])
    }else{
      next
    }
  }
  
}

data$calif <- calif
rm(data_na)

ggplot(data = data) +
  geom_histogram(aes(x = calif, y =  after_stat(density)),
                 bins = 30, color = "black", fill ="orange") +
  geom_rug(aes(x = calif)) +
  labs(title = "Distribución de Calificaciones sin valores nulos.",
       color = "Distribución") +
  theme_bw() +
  theme(legend.position = "bottom")


data %>% 
  group_by(provincia) %>% 
  summarise(mean(bruto_noche)) %>% 
  print(n=23)

data$calif <- round(data$calif, 2)
data$bruto_noche <- round(data$bruto_noche, 2)
data$precio_noche <- round(data$precio_noche, 2)
data$impuesto_noche <- round(data$impuesto_noche, 2)
save(data, file="data.Rda")


