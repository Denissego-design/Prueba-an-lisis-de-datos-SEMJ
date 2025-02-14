#

library(shiny)
library(tidyverse)
library(readr)
library(readxl)
library(plotly)
library(scales)
library(viridis)
library(csv)
library (DT)
options(scipen = 999)

ref_vic <- read_excel("C:/Users/gotod/Documents/curso_R/Input/Estatal-Víctimas-2015-2024_dic2024.xlsx")
ref_vic <- ref_vic %>%
  filter(Año > 2019)

anio <- ref_vic %>%
  mutate(Total = rowSums(across(Enero:Diciembre))) %>%
  filter(Año>2019) %>%
  group_by(Año, Sexo) %>%
  summarize("Total de víctimas por año" = sum(Total))

delito <- ref_vic %>%
  mutate(Total = rowSums(across(Enero:Diciembre))) %>%
  filter(Año>2019)%>%
  group_by(Sexo,`Tipo de delito`, Año) %>%
  summarize("Total de víctimas por tipo de delito" = sum(Total))

entidad <- ref_vic %>%
  mutate(Total = rowSums(across(Enero:Diciembre))) %>%
  filter(Año>2019)%>%
  group_by(Entidad, Sexo, Año) %>%
  summarize("Total de víctimas por entidad" = sum(Total))

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

server <- function(input, output) {
  output$vic_anio <- renderPlot({
    ggplot(anio, aes(x = as.character(Año), y =`Total de víctimas por año`, fill = Sexo)) +
      scale_fill_viridis_d(option = "A", begin = .3, end = .7) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Total de víctimas por año y sexo",
           subtitle = "2020-2024",
           x = "Año",
           y = "Víctimas",
           caption = "Fuente: SESNSP (2025). Victimas y unidades robadas.")
    })
  
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
    
    ggplotly(e, dynamicTicks = TRUE) %>%
      layout(
        font = list(
          family = "Tahoma",
          size = 12,
          color = "black"
        )
      )
    })
  
  output$vic_del <- renderPlotly({
    filtro_datos <- delito %>% filter(Año == input$Año)
    d <- ggplot(filtro_datos, aes( x = reorder(`Tipo de delito`,-`Total de víctimas por tipo de delito`), y =`Total de víctimas por tipo de delito`, fill = Sexo,
                                   text = paste("Delito: ", `Tipo de delito`, "<br>Víctimas: ", `Total de víctimas por tipo de delito`, "<br>Sexo: ", Sexo))) +
      scale_fill_viridis_d(option = "A", begin = .3, end = .7) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = paste("Víctimas por tipo de delito en:", input$Año),
           x = "Delito",
           y = "Víctimas") +
      coord_flip()
    
    ggplotly(d, dynamicTicks = TRUE, tooltip = "text") %>%
      layout(
        font = list(
          family = "Tahoma",
          size = 12,
          color = "black"
        )
      )
    })
    
  
  
    output$ref <- renderDataTable(
      ref_vic,
      options = list(lengthchange = TRUE)
  )
}

shinyApp(ui = ui, server = server)
