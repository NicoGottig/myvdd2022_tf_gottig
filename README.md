# Mapa Interactivo de Precios de Hospedaje en Argentina 2023

## Resumen
Esta aplicacion resume, seg�n distintos hospedajes de Booking para el a�o 2023 (y para dos personas adultas, sin hijos), los **precios**, la **cantidad** y la **puntuacion** de hoteles, caba�as y otros tipos de albergues en Argentina.

La informaci�n se recolect� a trav�s de t�cnicas de Web Scraping, se almacen� en una base de datos relacional, se transform� y se valid� para evitar valores nulos. No se realiz� un tratamiento de datos at�picos debido a que la selecci�n del rango de precios depende exclusivamente del usuario. 

Para la visualizaci�n se realiz� una aplicaci�n interactiva *Shiny*, con un mapa din�mico generado a trav�s del paquete *leaflet*.
<br>

## Objetivo y metodolog�a
El objetivo de la aplicaci�n es resumir y exponer informaci�n en funci�n de las solicitudes del usuario.
Para esto, se extrajo informaci�n sobre la localizaci�n, el precio, la descripci�n y el puntaje de m�s de 150.000 hospedajes en Argentina.<br>
Es **importante** tener en cuenta que el precio del hospedaje depende, entre otros factores, de la fecha de extracci�n de los datos. Por ejemplo, no es lo mismo buscar precios de hospedajes para el mes de enero, durante el mes de diciembre que durante el mes de octubre.  <br>
*En este caso, la extracci�n de los datos se realiz� durante el mes de diciembre y enero.*<br>

Por otro lado, para el **calculo de los estad�sticos** de precios, se realiz� un muestreo no probabil�stico; se seleccionaron $n$ ciudades por provincia en funci�n de consultas a empleados de empresas de servicios tur�sticos, y recomendaciones online.

El sitio *Booking* puede recomendar hospedajes de otras localidades, por lo tanto, para una cantidad $n$ de ciudades solicitadas se generar� una cantidad $k$ de ciudades disponibles, conteniendo cada una $h$ hospedajes, y as� para las 23 provincias (la Ciudad Aut�noma de Buenos Aires est� incluida en la provincia de Buenos Aires) <br>

La base de datos construida a trav�s de las t�cnicas de web scraping estar� compuesta por las siguientes variables:  <br>
+ **Localizaci�n**: Indica la ciudad del hospedaje.<br>
+ **Titulo**: Indica el t�tulo del hospedaje, como est� expuesto en Booking.<br>
+ **Descripcion**: Breve resumen del hospedaje.<br>
+ **Clasif**: Calificacion del hospedaje (del 1 al 10).<br>
+ **Precio**: Precio del hospedaje por el total de dias solicitados.<br>
+ **Impuesto**: Impuesto total por la cantidad de d�as solicitados.<br>
+ **Noches**: Cantidad de noches solicitadas  **Provincia**: Indica la provincia del hospedaje.<br>
+ **Checkin**: Fecha solicitada para el ingreso al hospedaje.<br>
+ **Checkout**: Fecha solicitada para el egreso del hospedaje.<br>
<br>

Adem�s, se construyen las siguientes variables:  <br>
+ **Precio_noche**: Precio neto por noche del hospedaje ($Precio_Noche=Precio/Noches$)  <br>
+ **Impuesto_noche**: Impuesto por noche del hospedaje ($Impuesto_noche=Impuesto/Noches$)<br>  
+ **Bruto_noche**: Precio total (incluyendo impuestos) ($Bruto_Noche=Precio_noche+Impuesto_Noche$)<br>

Con respecto a las fuentes de informaci�n, se utilizar� Booking por su facilidad de acceso a la informaci�n.<br>

Por lo tanto, los precios son considerados *"precios de mercado"*; es decir, incluyen los impuestos o subsidios, adem�s del valor agregado de las empresas que ofrecen el servicio.<br>

Con estas consideraciones, los estadisticos expuestos no pueden ser considerados un "indicador" de precios provinciales de hospedaje, limitando el an�lisis a la exploraci�n de los datos contextualizada en un momento determinado y en una regi�n dada.<br>

## Etapas:

#### 1 - Extracci�n de los datos:
Para la extracci�n de los datos se program� una funci�n que recoge una consulta (ej. Hospedajes de la ciudad de Paran�) e itinera las p�ginas disponibles en Booking recogiendo datos sobre cada hospedaje.
En caso de no encontrar datos, se reemplaza la celda por un valor nulo. Esto sucede principalmente en la calificaci�n de los hospedajes.
Para acercarnos a una nocion de representatividad, se dividieron las consultas en dos quincenas y luego se calculo un promedio de ambas.<br>

#### 2 - Manipulacion y Validacion:
Para constituir la base de datos final, se calcula el precio por noche sumando los impuestos y dividiendo por la cantida de noches solicitadas. 
Por otro lado, se eliminan los valores nulos existentes en el precio de hospedaje debido a las particularidades de �stos y se rellenan los valores de la calificaci�n en funci�n de su distribuci�n. [M�s informaci�n en el script](https://github.com/NicoGottig/myvdd2022_tf_gottig/blob/main/Scripts/02_tfi_manipulacion-validacion.R)<br>

#### 4 - Presentaci�n de la informaci�n:
Para la presentaci�n de la informaci�n se desarroll� una aplicaci�n interactiva *Shiny*. El usuario puede ingresar opciones de estilo y filtros de c�lculo para visualizar la informaci�n resumida en un mapa. Adem�s, puede consultar tablas resumidas y completas, permitiendo acceder la descripci�n de cada hospedaje. Para acceder a la aplicaci�n haga [click aqu�. ](www.shiny.com)<br>

