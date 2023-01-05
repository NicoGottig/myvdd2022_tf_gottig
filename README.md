# Mapa Interactivo de Precios de Hospedaje en Argentina 2023

## Resumen
Esta aplicacion resume, según distintos hospedajes de Booking para el año 2023 (y para dos personas adultas, sin hijos), los **precios**, la **cantidad** y la **puntuacion** de hoteles, cabañas y otros tipos de albergues en Argentina.

La información se recolectó a través de técnicas de Web Scraping, se almacenó en una base de datos relacional, se transformó y se validó para evitar valores nulos. No se realizó un tratamiento de datos atípicos debido a que la selección del rango de precios depende exclusivamente del usuario. 

Para la visualización se realizó una aplicación interactiva *Shiny*, con un mapa dinámico generado a través del paquete *leaflet*.
<br>

## Objetivo y metodología
El objetivo de la aplicación es resumir y exponer información en función de las solicitudes del usuario.
Para esto, se extrajo información sobre la localización, el precio, la descripción y el puntaje de m´s de 150.000 hospedajes en Argentina.<br>
Es **importante** tener en cuenta que el precio del hospedaje depende, entre otros factores, de la fecha de extracción de los datos. Por ejemplo, no es lo mismo buscar precios de hospedajes para el mes de enero, durante el mes de diciembre que durante el mes de octubre.  <br>
*En este caso, la extracción de los datos se realizó durante el mes de diciembre y enero.*<br>

Por otro lado, para el **calculo de los estadísticos** de precios, se realizó un muestreo no probabilístico; se seleccionaron $n$ ciudades por provincia en función de consultas a empleados de empresas de servicios turísticos, y recomendaciones online.

El sitio *Booking* puede recomendar hospedajes de otras localidades, por lo tanto, para una cantidad $n$ de ciudades solicitadas se generará una cantidad $k$ de ciudades disponibles, conteniendo cada una $h$ hospedajes, y así para las 23 provincias (la Ciudad Autónoma de Buenos Aires está incluida en la provincia de Buenos Aires) <br>

La base de datos construida a través de las técnicas de web scraping estará compuesta por las siguientes variables:  <br>
+ **Localización**: Indica la ciudad del hospedaje.<br>
+ **Titulo**: Indica el título del hospedaje, como está expuesto en Booking.<br>
+ **Descripcion**: Breve resumen del hospedaje.<br>
+ **Clasif**: Calificacion del hospedaje (del 1 al 10).<br>
+ **Precio**: Precio del hospedaje por el total de dias solicitados.<br>
+ **Impuesto**: Impuesto total por la cantidad de dìas solicitados.<br>   
+ **Noches**: Cantidad de noches solicitadas. <br>
+ **Provincia**: Indica la provincia del hospedaje.<br>
+ **Checkin**: Fecha solicitada para el ingreso al hospedaje.<br>
+ **Checkout**: Fecha solicitada para el egreso del hospedaje.<br>
<br>

Además, se construyen las siguientes variables:  <br>
+ **Precio_noche**: Precio neto por noche del hospedaje ($Precio_Noche=Precio/Noches$)  <br>
+ **Impuesto_noche**: Impuesto por noche del hospedaje ($Impuesto_noche=Impuesto/Noches$)<br>  
+ **Bruto_noche**: Precio total (incluyendo impuestos) ($Bruto_Noche=Precio_noche+Impuesto_Noche$)<br>

Con respecto a las fuentes de información, se utilizará Booking por su facilidad de acceso a la información.<br>

Por lo tanto, los precios son considerados *"precios de mercado"*; es decir, incluyen los impuestos o subsidios, además del valor agregado de las empresas que ofrecen el servicio.<br>

Con estas consideraciones, los estadisticos expuestos no pueden ser considerados un "indicador" de precios provinciales de hospedaje, limitando el análisis a la exploración de los datos contextualizada en un momento determinado y en una región dada.<br>

## Etapas:

#### 1 - Extracción de los datos:
Para la extracción de los datos se programó una función que recoge una consulta (ej. Hospedajes de la ciudad de Paraná) e itinera las páginas disponibles en Booking recogiendo datos sobre cada hospedaje.
En caso de no encontrar datos, se reemplaza la celda por un valor nulo. Esto sucede principalmente en la calificación de los hospedajes.
Para acercarnos a una nocion de representatividad, se dividieron las consultas en dos quincenas y luego se calculo un promedio de ambas.<br>

#### 2 - Manipulacion y Validacion:
Para constituir la base de datos final, se calcula el precio por noche sumando los impuestos y dividiendo por la cantida de noches solicitadas. 
Por otro lado, se eliminan los valores nulos existentes en el precio de hospedaje debido a las particularidades de éstos y se rellenan los valores de la calificación en función de su distribución. [Más información en el script](https://github.com/NicoGottig/myvdd2022_tf_gottig/blob/main/Scripts/02_tfi_manipulacion-validacion.R)<br>

#### 4 - Presentación de la información:
Para la presentación de la información se desarrolló una aplicación interactiva *Shiny*. El usuario puede ingresar opciones de estilo y filtros de cálculo para visualizar la información resumida en un mapa. Además, puede consultar tablas resumidas y completas, permitiendo acceder la descripción de cada hospedaje. Para acceder a la aplicación haga [click aquí. ](https://mj8qpg-nicolas-gottig.shinyapps.io/Mapa_Interactivo_Hospedajes_Argentina/?_ga=2.91187288.370091405.1672937106-2073232725.1672937106)<br>

