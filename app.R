rsconnect::setAccountInfo(name='mj8qpg-nicolas-gottig', token='0B17DDEA920AAB34F2FE5BE4F3683214', secret='mr15B3v7U55TFlM4QShzXHo2FFqMIpO4pLkcWJ3l')
library(rsconnect)
library(shiny)

# Definimos paquetes
library(tidyverse)
library(leaflet)
library(rgdal)
library(shinyWidgets)
library(shinydashboard)

load("data.Rda")

shapeData <- rgdal::readOGR(dsn = "pxpciadatosok.shp", verbose = FALSE)
shapeData <- sp::spTransform(shapeData, CRS("+proj=longlat +datum=WGS84 +no_defs"))
shapeData <- sf::st_as_sf(shapeData, wkt = 'polygons', crs = st_crs(4326)) # make sf
shapeData$provincia <- chartr("áéíóúÁÉÍÓÚàèìòùÀÈÌÒÙü", "aeiouAEIOUaeiouAEIOUu", x = shapeData$provincia)

# Servidor ---------------------------------------------------------------------
server <- function(input, output, session){
  
  # Crear dataframe reactivo
  df <- reactive({
    data %>%
      filter(bruto_noche >= input$pricerange[1] & bruto_noche <= input$pricerange[2]) %>% 
      filter(mes == input$month)
  })
  
  # Funcion para tablas completas ----------------------------------------------
  output$pricetable <- DT::renderDataTable({
    df <- df() 
    action <- DT::dataTableAjax(session, df, outputId = "pricetable")
    colnames(df) <- c("Provincia", "Localización", "Título", "Descripción", "Calificación", "Precio por noche", "Impuesto por noche", "Total por noche", "Mes")
    DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
    df
  })
  
  # Funcion para tablas resumen
  output$summarytable <- DT::renderDataTable({
    df <- df() %>% 
      group_by(provincia) %>% 
      summarise(Promedio = round(mean(bruto_noche), 2),
                Desv.Est. = round(sd(bruto_noche), 2),
                Variabil. = paste0(round((sd(bruto_noche) / Promedio) * 100, 2), "%"),
                Minimo = round(min(bruto_noche), 2), 
                Q1 = round(quantile(bruto_noche, .25), 2), 
                Mediana = round(median(bruto_noche), 2), 
                Q3 = round(quantile(bruto_noche, .75), 2),
                Máximo = round(max(bruto_noche),2))
    action <- DT::dataTableAjax(session, df, outputId = "summarytable")
    DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
    df
  })
  
  #### MAPAS PARA PRECIOS ------------------------------------------------------
  # Funcion que crea el mapa interactivo con la media
  output$mapmean <- renderLeaflet({ 
    
    bins <- c(0, quantile(df()$bruto_noche, .25), 
              quantile(df()$bruto_noche, .50),
              quantile(df()$bruto_noche, .75),
              quantile(df()$bruto_noche, 1))
    
    df <- df() %>% 
      group_by(provincia) %>% 
      summarise(mean = mean(bruto_noche),
                median = median(bruto_noche),
                min = min(bruto_noche),
                max = max(bruto_noche),
                sdpr = sd(bruto_noche),
                vc = sdpr/mean)
    
    mapdata <- sp::merge(shapeData, df, by.x = "provincia", by.y = "provincia")
    
    pal = colorBin(input$cpalet, mapdata$mean, bins = bins)
    
    textos <- paste0("<b>", mapdata$provincia, "</b>",
                     "<br><b>Precio de hospedaje promedio: </b> $",
                     round(mapdata$mean),
                     "<br><b>Desvío Estandar: </b>$",
                     round(mapdata$sdpr),
                     "<br><b>Coef. de Variación: </b>",
                     round(mapdata$vc, 2)*100, "%"
    )
    
    m <- leaflet(mapdata) %>% 
      addProviderTiles(input$mapaes) %>% 
      setView(-54, -40, 4) %>% 
      addPolygons(weight = 2,
                  color = "black", 
                  dashArray = "1",
                  fillColor = ~pal(mean),
                  fillOpacity = input$alpha,
                  highlight = highlightOptions(weight = 3,
                                               color = "orange",
                                               dashArray = "",
                                               fillOpacity = 0.7,
                                               bringToFront = TRUE),
                  label = ~lapply(as.list(textos), htmltools::HTML),
                  labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"),
                                              textsize = "15px",
                                              direction = "auto")
      ) %>% 
      addLegend(pal = pal, values = ~mean, opacity = 0.7, 
                title = "Precios de Hospedaje por Noche", position = "bottomright")
    m
  })
  
  # Mapa con mediana
  output$mapmedian <- renderLeaflet({ 
    
    bins <- c(0, quantile(df()$bruto_noche, .25), 
              quantile(df()$bruto_noche, .50),
              quantile(df()$bruto_noche, .75),
              quantile(df()$bruto_noche, 1))
    
    df <- df() %>% 
      group_by(provincia) %>% 
      summarise(mean = mean(bruto_noche),
                median = median(bruto_noche),
                min = min(bruto_noche),
                max = max(bruto_noche),
                vc = sd(bruto_noche)/mean)
    
    mapdata <- sp::merge(shapeData, df, by.x = "provincia", by.y = "provincia")
    
    pal = colorBin(input$cpalet, mapdata$median, bins = bins)
    
    textos <- paste0("<b>", mapdata$provincia, "</b>",
                     "<br><b>El 50% de los precios asciende hasta: </b> $",
                     round(mapdata$median),
                     "<br><b>Precio máximo: </b>$",
                     round(mapdata$max),
                     "<br><b>Precio mínimo: </b>$",
                     round(mapdata$min)
    )
    
    m <- leaflet(mapdata) %>% 
      addProviderTiles(input$mapaes) %>% 
      setView(-54, -40, 4) %>% 
      addPolygons(weight = 2,
                  color = "black", 
                  dashArray = "1",
                  fillColor = ~pal(median),
                  fillOpacity = input$alpha,
                  highlight = highlightOptions(weight = 3,
                                               color = "orange",
                                               dashArray = "",
                                               fillOpacity = 0.7,
                                               bringToFront = TRUE),
                  label = ~lapply(as.list(textos), htmltools::HTML),
                  labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"),
                                              textsize = "15px",
                                              direction = "auto")
      ) %>% 
      addLegend(pal = pal, values = ~median, opacity = 0.7, 
                title = "Precios de Hospedaje por Noche", position = "bottomright")
    m
  })
  
  #### MAPAS PARA CALIFICACION -------------------------------------------------
  output$mapcalif <- renderLeaflet({ 
    
    bins <- c(0, quantile(df()$calif, .25), 
              quantile(df()$calif, .50),
              quantile(df()$calif, .75),
              quantile(df()$calif, 1))
    
    df <- df() %>% 
      group_by(provincia) %>% 
      summarise(mean = mean(calif),
                median = median(calif),
                min = min(calif),
                sdc = sd(calif),
                max = max(calif),
                vc = sd(calif)/mean)
    
    mapdata <- sp::merge(shapeData, df, by.x = "provincia", by.y = "provincia")
    
    pal = colorBin(input$cpalet, mapdata$mean, bins = bins)
    
    textos <- paste0("<b>", mapdata$provincia, "</b>",
                     "<br><b>Calificación promedio: </b>",
                     round(mapdata$mean, 2),
                     "<br><b>Desvío: </b>",
                     round(mapdata$sdc, 2),
                     "<br><b>Calificación máxima: </b>",
                     round(mapdata$max, 2),
                     "<br><b>Calificación mínima: </b>",
                     round(mapdata$min, 2)
    )
    
    m <- leaflet(mapdata) %>% 
      addProviderTiles(input$mapaes) %>% 
      setView(-54, -40, 4) %>% 
      addPolygons(weight = 2,
                  color = "black", 
                  dashArray = "1",
                  fillColor = ~pal(mean),
                  fillOpacity = input$alpha,
                  highlight = highlightOptions(weight = 3,
                                               color = "orange",
                                               dashArray = "",
                                               fillOpacity = 0.7,
                                               bringToFront = TRUE),
                  label = ~lapply(as.list(textos), htmltools::HTML),
                  labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"),
                                              textsize = "15px",
                                              direction = "auto")
      ) %>% 
      addLegend(pal = pal, values = ~mean, opacity = 0.7, 
                title = "Calificación de los Hospedajes", position = "bottomright")
    m
  })
  
  #### MAPAS PARA CANTIDADES ---------------------------------------------------
  output$mapnum <- renderLeaflet({ 
    
    
    df <- df() %>% 
      group_by(provincia) %>% 
      summarise(num = n())
    
    bins <- c(0, quantile(df$num, .25), 
              quantile(df$num, .50),
              quantile(df$num, .75),
              quantile(df$num, 1))
    
    mapdata <- sp::merge(shapeData, df, by.x = "provincia", by.y = "provincia")
    
    pal = colorBin(input$cpalet, mapdata$num, bins = bins)
    
    textos <- paste0("<b>", mapdata$provincia, "</b>",
                     "<br><b>Cantidad: </b>",
                     mapdata$num)
    
    m <- leaflet(mapdata) %>% 
      addProviderTiles(input$mapaes) %>% 
      setView(-54, -40, 4) %>% 
      addPolygons(weight = 2,
                  color = "black", 
                  dashArray = "1",
                  fillColor = ~pal(num),
                  fillOpacity = input$alpha,
                  highlight = highlightOptions(weight = 3,
                                               color = "orange",
                                               dashArray = "",
                                               fillOpacity = 0.7,
                                               bringToFront = TRUE),
                  label = ~lapply(as.list(textos), htmltools::HTML),
                  labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"),
                                              textsize = "15px",
                                              direction = "auto")
      ) %>% 
      addLegend(pal = pal, values = ~num, opacity = 0.7, 
                title = "Cantidad de Hospedajes por provincia", position = "bottomright")
    m
  })
  
  
  
}

# UI ------------
ui <- navbarPage("Mapa Interactivo de Precios de Hospedaje",
                 tabPanel("Mapa",
                          sidebarLayout(
                            sidebarPanel(
                              
                              h4(strong("FILTROS")),
                              
                              sliderInput("pricerange",
                                          "Rango de precios: ",
                                          value = c(2000, 10000),
                                          min = 0,
                                          max = 150000),
                              
                              pickerInput(
                                inputId = "month",
                                label = "Mes de hospedaje:", 
                                choices = c("enero" = 1,
                                            "febrero" = 2,
                                            "marzo" = 3,
                                            "abril" = 4,
                                            "mayo" = 5,
                                            "junio" = 6,
                                            "julio" = 7,
                                            "agosto" = 8,
                                            "septiembre" = 9,
                                            "octubre" = 10,
                                            "noviembre" = 11,
                                            "diciembre" = 12),
                                selected = 2
                              ),
                              
                              pickerInput(
                                inputId = "info",
                                label = "Información: ", 
                                choices = c("Precios promedio" = "precios", "Cantidad de Hospedajes" = "num", "Calif. Promedio" = "calif"),
                                selected = "precios"),
                              
                              conditionalPanel("input.info == 'precios'",
                                               awesomeRadio("stats",
                                                            "Seleccionar medida: ",
                                                            choices = c("Promedio" = 1, "Mediana" = 0),
                                                            selected = 1,
                                                            status = "warning")),
                              
                              hr(),
                              
                              h4(strong("OPCIONES DEL MAPA")),
                              pickerInput(
                                inputId = "mapaes",
                                label = "Estilo del mapa", 
                                choices = c("Día" = "OpenStreetMap", "Noche" = "Stamen.Toner"),
                                selected = "OpenStreetMap"),
                              
                              pickerInput(
                                inputId = "cpalet",
                                label = "Paleta de colores", 
                                choices = c("Cálida" = "YlOrRd", 
                                            "Fria" = "Blues", 
                                            "Púrpura" = "PuRd", 
                                            "Verde" = "BuGn"),
                                selected = "PuRd"),
                              
                              sliderTextInput(
                                inputId = "alpha",
                                label = "Transparencia del mapa:", 
                                choices = round(seq(0, 1, 0.05),2),
                                grid = TRUE,
                                selected = 0.85),
                              p(em(" * El mapa puede tardar en cargar."), style = "font-size:12px")
                              
                              
                            ),
                            
                            mainPanel(
                              conditionalPanel(
                                condition = "input.info == 'precios' & input.stats == 1",
                                leafletOutput("mapmean", height = "90vh")),
                              
                              conditionalPanel(
                                condition = "input.info == 'precios' & input.stats == 0",
                                leafletOutput("mapmedian", height = "90vh")),
                              
                              conditionalPanel(
                                condition = "input.info == 'calif'",
                                leafletOutput("mapcalif", height = "90vh")),
                              
                              conditionalPanel(
                                condition = "input.info == 'num'",
                                leafletOutput("mapnum", height = "90vh"))
                              )
                            
                          )
                 ),
                 
                 #### tabpanels ------------------------------------------------
                 tabPanel("Tabla Completa",
                          DT::dataTableOutput("pricetable")),
                 
                 tabPanel("Tabla Resumida",
                          DT::dataTableOutput("summarytable")),
                 
                 tabPanel("Acerca De",
                          sidebarLayout(
                            sidebarPanel(h4(strong("Resumen")),
                                         p(strong("AUTOR | "), " Nicolás Gottig"),
                                         p(strong("FECHA | "), " Febrero - 2023"),
                                         p(strong("CONSULTA DE DATOS | "), "Diciembre - 2022 y enero 2023."),
                                         p(strong("CODIGO DISPONIBLE EN | "), a(href = 'https://github.com/NicoGottig/myvdd2022_tf_gottig', 'GitHub', .noWS = "outside")),
                                         p(strong("PAQUETES UTILIZADOS | "), 
                                           "Tidyverse, Leaflet, Shiny, Rvest, readODS,
                                           Lubridate, Naniar, Zoo, Janitor, Haven, UnivariateML,
                                           rgdal, sf, sp.")
                                         
                            ),
                            mainPanel(
                              h1("Mapa Interactivo de Hospedajes de Argentina"),
                              h4("Trabajo Práctico Final para el Curso", em(" Manejo y Visualización de Datos,"), "de la ", em("Maestría en Estadística Aplicada (FCEyE-UNR)")),
                              hr(),
                              p(em("Fecha de extracción de los datos: diciembre 2022 y enero 2023.")),
                              p("Primera versión del", strong("Mapa Interactivo de Hospedajes de Argentina."), "Los datos fueron extraídos durante el mes de diciembre y enero. Es importante tener en cuenta esto ya que incide en los precios 
                                de hospedajes cercanos en tiempo. La base de datos se creo mediante técnicas de web scraping (paquete RVest) y paquetes del universo Tidy, y son 
                                presentados a través del uso de repositorios como Tidyverse, Leaflet y Shiny, entre otras. ", align = "justify"),
                              hr(),
                              p(strong("Para cada provincia se realiza la búsqueda con las siguientes características: "), align = "justify"),
                              p(align = "justify", "* Departamento, hotel o cabaña para dos personas adultas, sin hijos."),
                              p(align = "justify", "* Hospedaje entre los días 1 a 15 y 15 a 31. "),
                              hr(),
                              p(align = "justify", strong("Los filtros disponibles son: ")),
                              p(align = "justify", strong("* Rango de precios:"), ": Selecciona que departamentos exponer a través de un rango de precios. "),
                              p(align = "justify", strong("* Mes:"), "Selecciona el mes de hospedaje. Cambia el mes de búsqueda. Cada mes está representado por dos quincenas. Por ejemplo, julio resume los precios de hospedajes según reservas para los días del 1 al 15, y del 15 al 31."),
                              p(align = "justify", strong("* Medidas:"), "El promedio se ve afectado por valores muy altos o muy bajos. La mediana es robusta a estos valores, pero no ponedera los precios según su frecuencia."),
                              p(align = "justify", strong("* Mostrar:"), "Seleccione que información exponer en el mapa (precios, cantidad de hospedajes o valoración."),
                              br(),
                              p(align = "justify", strong("Las opciones de visualización son: ")),
                              p(align = "justify", strong("* Mapa base:"), "Selecciona el estilo del mapa. "),
                              p(align = "justify", strong("* Transparencia:"), "Cambia la transparencia del mapa coroplético.  "),
                              p(align = "justify", strong("* Paleta:"), "Cambia la paleta de colores del mapa coroplético. "),
                              hr(),
                              p(align = "justify", strong("Para las próximas versiones se espera: "), align = "justify"),
                              p("- Trabajar en el diseño muestral para obtener un valor representativo de las provincias.", align = "justify"),
                              p(align = "justify", "- Optimizar la función de recolección de datos."),
                              p(align = "justify", "- Mejorar la reactividad del mapa respecto a las opciones del usuario. "),
                              hr(),
                              p(em("Mapa Interactivo de Hospedajes de Argentina. 2023. "))
                            )
                          )
                 )
)


shinyApp(ui, server)
