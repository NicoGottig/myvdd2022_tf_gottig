# Funcion scrap_booking ---------
# Funcion que toma como argumento una página web, un año, una determinada cantidad de páginas (n),
# la fecha de checkin y la de checkout, y devuelve un dataframe. Cada fila representa un hospedaje
# (clase apart) mientras que las variables que recoge son localizacion, titulo, descripcion, calif, precio, impuesto, noches

# Funcion get_info_booking ------
# Funcion que recoge una base de datos con las variables: provincia (ej. Formosa), ciudad (ej. Pirané),
# el enlace de booking que corresponde a la búsqueda en esa localidad, la cantidad de páginas, 
# el año, mes, día de check in y día de check out de una búsqueda, y devuelve un dataframe con las variables
# nombradas en la función anterior.

# Ambas funciones podrían integrarse en una sola.
# Además, podría definirse un atributo como "cantidad de habitaciones", "cantidad de adultos", o "cantidad de niños"
# y recoger los resultados de los hospedajes en función de estas características.
# También pueden programarse mas validaciones internas para asegurar la ejecución óptimizada del algoritmo. 

# Definimos paquetes
paquetes <- c("XML")

# Instalar si no estÃ¡n instalados
instalados <- paquetes %in% rownames(installed.packages())
if (any(instalados == FALSE)) {
  install.packages(paquetes[!instalados])
}

# Cargarlos al entorno paquetes
invisible(lapply(paquetes, library, character.only = TRUE))
rm(instalados, paquetes)

# Funcion para extraer información dado un link
scrap_booking <- function(web, n = 0, year, month, dcheckin, dcheckout){
  
  # Toma como input página web y elimina los atributos de check in y check out para añadirlos
  # a travès de los parámetros ingresados.
  web_list <- str_split(web, "&") %>% 
    data.frame()
  colnames(web_list) <- "partes"
  web_list <- web_list %>% 
    filter(!grepl("(checkin|checkout)", partes))
  web0 <- str_flatten(web_list$partes, collapse = "&")
  web = paste0(web0, "&checkin_year=", year, "&checkin_month=", month, "&checkin_monthday=", 
               dcheckin, "&checkout_year=", year, "&checkout_month=", 
               month, "&checkout_monthday=", 
               dcheckout, "&flex_window=0&efdco=1&group_adults=2&group_children=0&no_rooms=1&b_h4u_keep_filters=&from_sf=")
  
  # Define las clases de interés
  class_calificacion <- ".d10a6220b4" # Puntaje del hospedaje
  class_titulo <- ".a23c043802" # Titulo del hospedaje
  class_descrip <- ".bb58e7a787" # Descripcion del hospedaje
  class_impuesto <- ".d8eab2cf7f" # Impuestos de la publicaci?n
  class_precio <- ".e6e585da68" # Precio de la publicaci?n
  class_local <- ".b4273d69aa" # Localidad de la publicaci?n
  class_noches <- ".d8eab2cf7f" # Cantida de noches por alquiler
  apart <- ".f996d8c258:only-child" # Elemento que almacena cada departamento
  
  # Define vectores vacíos para rellenar con los resultados.
  impuesto <- vector()
  precio <- vector()
  noches <- vector()
  calif <- vector()
  titulo <- vector()
  descripcion <- vector()
  localizacion <- vector()
  
  # crea un objeto para rellenar con los vectores definidos previamente, en cada itineraci?n
  data <- NULL
  
  # el atributo "offset" de booking define a la p?gina 0 = 0, 1 = 25, 2 = 50, ... x = 25*q donde 
  # x es el valor que le corresponde al atributo, y q es la p?gina de b?squeda. 
  # Si el usuario ingresa 0, no le resta -1.
  if (n == 0) {
    n = n
    
  }else{
    n = n-1
    n = 25*n
  }
  
  # El bucle realiza los mismos procedimientos para cada p?gina de b?squeda.
  for (i in seq(0, n, 25)) {
    
    # El objeto devuelve el enlace para cada p?gina
    webscrap <- paste0(web, "&offset=", i)
    
    # Extraemos el c?digo fuente -eliminado paste0-
    html <- rvest::read_html(webscrap)
    
    # Validamos que diga "x alojamientos encontrados..." 
    # si no lo hace, pasa a la siguiente p?gina.
    validacion <- html %>% 
      rvest::html_nodes(".d3a14d00da") %>% 
      rvest::html_text()
    
    # Si hay informaci?n sobre alquileres en la página, se recoge información sobre cada 
    # clase definida previamente.
    if (identical(validacion, character(0)) == FALSE && grepl("0 alojamientos", validacion) == FALSE) {
      
      # Extrae cada hospedaje  
      child_html <- rvest::html_nodes(html, apart)
      
      # Para cada uno de los elementos (hospedajes)...
      for (j in 1:length(child_html)){
        
        # ... extraigo el elemento, lo convierto en texto... 
        cache_titulo <- child_html[j] %>% 
          rvest::html_nodes(class_titulo) %>% 
          rvest::html_text()
        
        # ...y si no es un NA!, lo almaceno en el vector.
        len <- length(cache_titulo)
        if(len != 0){
          titulo[j] <- cache_titulo
        }else{
          titulo[j] <- NA
        }
        
        cache_calif <- child_html[j] %>% 
          rvest::html_nodes(class_calificacion) %>% 
          rvest::html_text()
        len <- length(cache_calif)
        if (len != 0) {
          calif[j] <- cache_calif
        }else{
          calif[j] <- NA
        }
        
        cache_precio <- child_html[j] %>% 
          rvest::html_nodes(class_precio) %>% 
          rvest::html_text()
        len <- length(cache_precio[3])
        valid_string <- sum(str_detect(cache_precio, "\\$")) == 1
        if (len != 0 && valid_string == TRUE) {
          precio[j] <- cache_precio[grep("\\$", cache_precio)]
        }else{
          calif[j] <- NA
        }
        
        cache_imp <- child_html[j] %>% 
          rvest::html_nodes(class_impuesto) %>% 
          rvest::html_text()
        len <- length(cache_imp)
        valid_string <- sum(str_detect(cache_imp, "impuestos")) == 1
        if (len != 0 && valid_string == TRUE) {
          impuesto[j] <- cache_imp[grep("impuestos", cache_imp)]
        }else{
          impuesto[j] <- NA
        }
        
        cache_local <- child_html[j] %>%
          rvest::html_nodes(class_local) %>%
          rvest::html_text()
        len <- length(cache_local)
        if(len != 0){
          localizacion[j] <- cache_local[1]
        }else{
          localizacion[j] <- NA
        }
        
        cache_descrip <- child_html[j] %>% 
          rvest::html_nodes(class_descrip) %>%
          rvest::html_text() %>% 
          str_flatten(collapse = ", ")
        len <- length(cache_descrip)
        if(len != 0){
          descripcion[j] <- cache_descrip
        }else{
          descripcion[j] <- NA
        }
        
        # Para cada elemento se puede validar que cumpla una determinada condición antes de 
        # ser almacenado
        cache_noches <- child_html[j] %>% 
          rvest::html_nodes(class_noches) %>%
          rvest::html_text()
        len <- length(cache_noches)
        valid_string <- sum(str_detect(cache_noches, "noches")) == 1
        if (len != 0 && valid_string == TRUE) {
          noches[j] <- cache_noches[grepl("noches", cache_noches)]
        }else{
          noches[j] <- NA
        }
        
      }
      
      # Se almacenan los vectores en un dataframe, se lo almacena en la base de datos final
      # y se imprimen cuantos hospedajes se añadieron.
      data_page <- cbind(localizacion, titulo, descripcion, calif, precio, impuesto, noches) %>% 
        data.frame()
      data <- bind_rows(data, data_page)
      print(paste0("Página ", (i/25)+1, " lista. Se añadieron ", nrow(data_page), " filas."))
      
    }else{
      print("No hay datos.")
      break
    }
    
    # Si el índice de la página es múltiplo de 10, se detiene durante 60 segundos para evitar
    # ser baneados de la página.

  }
  return(data)
}


get_info_booking <- function(provincia, ciudad, links, n_pages, year, month, dcheckin, dcheckout){

  # Se crea el elemento que almacenará los datos
  hospedaje <- NULL
  
  # El bucle utiliza la función scrap_booking para cada fila del set de datos del input. 
  for (i in 1:length(links)) {
    print(paste0("Iniciando extracci?n de alojamientos de ", ciudad[i], ", provincia de ", provincia[i], "."))
    data <- NULL
    data <- scrap_booking(web = links[i],
                          n = n_pages,
                          year = year,
                          month = month,
                          dcheckin = dcheckin,
                          dcheckout = dcheckout)
    
    # Si el valor de data no es nulo, se almacena en el dataframe con la información de ingreso y salida.
    if (!is.null(data)) {
      ci = paste0(year, "-", month, "-", dcheckin)
      co = paste0(year, "-", month, "-", dcheckout)
      data <- cbind(data, provincia = provincia[i], checkin = ci, checkout = co)
      hospedaje <- rbind(hospedaje, data)
    }
  
  # Si el número índice es múltiplo de 3, el sistema se pausa durante 60 segundos para evitar ser baneados
  # de la web
    
    if ((i %% 3) == 0) {
      Sys.sleep(30)
    }
  }
  print("Extracci?n finalizada.")
  return(hospedaje)
}
