#' Visualización rápida del discurso
#'  (\emph{Quick speech viz})
#'  
#' @description
#' Función que permite una rápida visualización de los discursos presidenciales a través de nube de palabras representando su frecuencia relativa con el tamaño. 
#'  (\emph{Function that plots a word cloud of presidential specches, with word sizes as a function of its frequency in the data set})
#'  
#' @param data requiere un discurso dentro data.frame con formato \emph{tidy} descargado con \code{get_speech} 
#' \emph{(a tidy data.frame with the speech downloaded with \code{get_speech} is required}).
#'  
#' @return Devuelve un objeto con clases \code{"wordcloud2" "htmlwidget"} que representa gráficamente el contenido de un discurso presidencial  
#'  (\emph{it retruns an object of \code{classes "wordcloud2" "htmlwidget"}} with a graphical representation of presidential speeches).
#'  
#'
#'    
#'@export

plot_speech <- function(data){

  data <- data %>% 
    dplyr::group_by(word) %>% 
    dplyr::summarise(n = dplyr::n()) %>% 
    dplyr::arrange(dplyr::desc(n)) 
  
    wordcloud2::wordcloud2(data = data,
                           backgroundColor = "black")

}
