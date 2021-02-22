#'Obtiene nombres de listas (\emph{Get party names})

#'@description
#'Función que agrega el nombre de las listas o partidos como columna a un tibble obtenido con \code{\link{get_election_data}(long = TRUE)} 
#' (\emph{Function that adds party labels as a column to a tibble obtained with \code{\link{get_election_data}(long = TRUE)}}).
#' 
#'@param data un tibble descargado con \code{\link{get_election_data}(long = TRUE)} guardado como objeto en el Enviroment  
#' (\emph{A \code{\link{get_election_data}(long = TRUE)} tibble saved as an object in the Enviroment}).
#' 
#'@details El formato de \code{data} debe ser \code{long} para poder obtener 
#' nombres de listas con \code{\link{get_names}}. Si \code{data} es \emph{wide} se puede transformar con \code{\link{make_long}} 
#' (\emph{\code{long} format of \code{data} is required to get party labels with \code{\link{get_names}}.  If \code{data} is in
#' \emph{wide} format you can transform it with \code{\link{make_long}}}).   
#' 
#'@return Devuelve el data set original con una columna extra con la identifiacion de las listas o partidos politicos. 
#' Como el objeto de entrada, este es \code{class "tbl_df","tbl","data.frame"} 
#' (\emph{it retruns the original data set with a binded column with political parties names. 
#'  As the original input the object is of \code{class "tbl_df","tbl","data.frame"}}).
#'  
#'@examples
#'  
#'  tucuman_dip_gral_2017
#'  
#'  tucuman_dip_gral_2017 %>% 
#'      get_names()
#'    
#'@export

get_names <- function(data){

  ## Check for internet coection
  attempt::stop_if_not(.x = curl::has_internet(),
                       msg = "Internet access was not detected. Please check your connection // 
No se detecto acceso a internet. Por favor chequear la conexion.")
  
  # chek data format - LONG needed
  
  assertthat::assert_that("listas" %in% colnames(data), 
                          msg = "data is not in a long format. Use 'make_long()' to transform it //
Los datos no estan en un formato largo. Use 'make_long ()' para transformarlos")
          
    
        category <- unique(data$category)
        
        round <- unique(data$round)  
        
        year <- unique(data$year) 
        
        
        url <- glue::glue('https://raw.githubusercontent.com/electorArg/PolAr_Data/master/listas/listas_', 
                          {category}, '_',  
                          {round}, 
                          {year}, '.csv')
        
        ## FAIL SAFELEY
        
        check <- httr::GET(url)
        
        httr::stop_for_status(x = check, 
                              task = "Fail to download lists data. Source is not available // La fuente de datos de listas no esta disponible")
        
        
        ## GET DATA  
        
        listas_gh <- readr::read_csv(file = url, 
                                     col_types = readr::cols()) %>%
          dplyr::rename(listas = vot_parCodigo, 
                        codprov = vot_proCodigoProvincia, 
                        nombre_lista = parDenominacion)
    
          
        
       
        data %>% 
          dplyr::left_join(listas_gh, by = c('listas', 'codprov')) %>% 
          dplyr::mutate(nombre_lista = dplyr::case_when(
            is.na(nombre_lista) ~ listas, 
            T ~ nombre_lista
         
            
             ))
        }

