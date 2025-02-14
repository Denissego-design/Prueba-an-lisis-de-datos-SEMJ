
# Prueba análisis de datos-SM

- Desarrollar una Shiny App que permita visualizar datos de víctimas en México obtenidas por el SESNSP.
- Análisis de datos de víctimas durante el periodo 2020-2024.
- La Shiny App se encuentra alojada en este repositorio de Git Hub para que puedan acceder a ella y duplicarlo.
- A continuación encontrarás información sobre cóno generar una Shiny App para análisis de datos con gráficas estáticas y dinámicas, así como tablas de referencia.
- By: Denissego-design.

## Demo

Fuente: SESNSP. (2025). Víctimas y unidades robadas. Víctimas del Fuero Común 2015-2024.
https://drive.google.com/file/d/1XIWTAMwOs8s5XAlJDlG0kJBoGtYVn8pZ/view 
## Funcionalidades

- Genera análisis de datos de forma más práctica. 
- Proporciona visualizaciones dinámicas para mejor comprensión de los datos.
- Organiza la información de una forma clara y concisa.



## Tech Stack

**Generador de código:** R





## Installation

Recuerda instalar algunas librerías que deberás tener en R para poder generar todos los cambios en las diversas visualizaciones de datos por realizar.

```bash
library(shiny)
library(tidyverse)
library(readr)
library(readxl)
library(plotly)
library(scales)
library(viridis)
library(csv)
library (DT)Node, Express
```
    
## Usage/Examples

```R
Antes de iniciar recuerda que R coloca números en notación científica, por lo cual, en el caso de las gráficas a realizar necesitamos números enteros así que, antes de inicar el código utiliza el siguiente código para cambiar la presentación de los números.
Función:
options(scipen = 999)}


```Recuerda seccionar desde el inicio los datos que quieres presentar en cada una de tus gráficas. Aquí te dejo un ejemplo de cómo hacerlo:

anio <- ref_vic %>%
  mutate(Total = rowSums(across(Enero:Diciembre))) %>%
  filter(Año>2019) %>%
  group_by(Año, Sexo) %>%
  summarize("Total de víctimas por año" = sum(Total))

```La estructura del *ui* es importante para saber qué es lo que queremos presentar en nuestra estructura gráfica por lo cual, en este caso, utilizamos algunos botones dnámicos, no obstante, debido a que no todos son gráficos dinámicos, utilizamos un comando que permite visualizar el botón dinámico solo en los espacios necesarios como se muestra en el siguiente código

*Función: conditionalPanel(
    condition = "input.tabs == 'victimas_edo' || input.tabs == 'victimas_del'",*
*Función: id = "tabs",
        tabPanel("Resumen",* value = "resumen" *, plotOutput("vic_anio")),



anio <- ref_vic %>%
  ui <- fluidPage(
  
  titlePanel("Análisis de Datos de Víctimas del Fuero Común (SESNSP, 2020-2024)"),
   
  conditionalPanel(
    condition = "input.tabs == 'victimas_edo' || input.tabs == 'victimas_del'",
  fluidRow(
    column(2,
      sliderInput("Año",
                  "Seleccione el año:",
                  min = 2020,
                  max = 2024,
                  value = 2020,
                  step = 1)
    )
    )
  ),
  mainPanel(
      tabsetPanel(
        id = "tabs",
        tabPanel("Resumen", value = "resumen", plotOutput("vic_anio")),
        tabPanel("Víctimas por entidad", value = "victimas_edo", plotlyOutput("vic_edo")),
        tabPanel("Víctimas por tipo de delito", value = "victimas_del", plotlyOutput("vic_del")),
        tabPanel("Referencias", value = "referencias", dataTableOutput("ref"))
      )
    )
  )



Para el procesamiento de datos utilizamos server, por lo cual, determinamos qué datos vamos a trabajar en cada gráfica y determinamos el diseño de los datos a presentar.

server <- function(input, output) {
  output$vic_anio <- renderPlot({
    ggplot(anio, aes(x = as.character(Año), y =`Total de víctimas por año`, fill = Sexo)) +


Para el uso de colores y tamaño del gráfico se utilizó el siguiente código: 
      scale_fill_viridis_d(option = "A", begin = .3, end = .7) +
      geom_bar(stat = "identity") +
      theme_minimal() +

Una vez elegido el diseño del gráfico, mediante este código se colocaron las leyendas que permitirán reconocer de manera clara la información presentada.

      labs(title = "Total de víctimas por año y sexo",
           subtitle = "2020-2024",
           x = "Año",
           y = "Víctimas",
           caption = "Fuente: SESNSP (2025). Victimas y unidades robadas.")

En cuanto a las gráficas dinámicas el inicio del código fue distinto, ya que en la primera utilizamos ggplot y en aquellas dinámicas se utilizó plotly como se muestra a continuación: 

    output$vic_edo <- renderPlotly({
    filtro_datos <- entidad %>% filter(Año == input$Año)
    e <- ggplot(filtro_datos, aes(x = Entidad, y =`Total de víctimas por entidad`, fill = Sexo)) +
      scale_fill_viridis_d(option = "A", begin = .3, end = .7) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = paste("Víctimas por entidad en:", input$Año),
           x = "Entidad",
           y = "Víctimas") +
      coord_flip()


Finalmente para añadir las referencias utilizadas, partimos de utilizar el siguiente código para generar una tabla dinámica para consultar la información en las gráficas presentadas.

        output$ref <- renderDataTable(
      ref_vic,
      options = list(lengthchange = TRUE)


Y por último, para correr tu Shiny App recuerda colocar el siguiente código:

        shinyApp(ui = ui, server = server)

## Screenshots

![App Screenshot]("C:/Users/gotod/Documents/curso_R/PruebaSESNSP/Grafica1.png")
![App Screenshot]("C:/Users/gotod/Documents/curso_R/PruebaSESNSP/Grafica2.png)
![App Screenshot]("C:/Users/gotod/Documents/curso_R/PruebaSESNSP/Grafica3.png)
![App Screenshot]("C:/Users/gotod/Documents/curso_R/PruebaSESNSP/Referencia.png")
