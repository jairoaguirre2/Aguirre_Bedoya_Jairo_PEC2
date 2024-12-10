### Diccionario de datos y resultados

workingDir <-getwd()
dataDir <- file.path(workingDir, "datos")
resultsDir <- file.path(workingDir, "resultados")

### Instalación de paquetes 
#r paquetes, message = FALSE, warning = FALSE, results = "hide"
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

installifnot <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    BiocManager::install(pkg)
  }
}

paquetes <- c(
  "pd.mogene.2.1.st", "mogene21sttranscriptcluster.db", "oligo", "limma", 
  "Biobase", "arrayQualityMetrics", "genefilter", "annotate", "xtable", 
  "gplots", "GOstats", "knitr", "colorspace", "ggplot2", "ggrepel", 
  "htmlTable", "prettydoc", "devtools", "pvca", "org.Mm.eg.db", 
  "ReactomePA", "reactome.db"
)

lapply(paquetes, installifnot)

## Leemos el archivo target y creamos un objeto de tipo AnnotatedDataFrame

library(Biobase)

#Leemos el archivo targets
allTargets <- read.table (
  "C:/Users/JUNIOR/Documents/MÁSTER/ANÁLISIS DATOS ÓMICOS/PEC2/allTargets.txt", 
  header = TRUE, 
  sep=" ")

#Vemos un resumen de los datos
str(allTargets)

#Creamos función para filtrar los datos

filter_microarray <- function(allTargets, seed = 52904568) {
  # Configurar la semilla aleatoria
  set.seed(seed)
  
  # Filtrar las filas donde 'time' no sea 'hour 2'
  filtered <- subset(allTargets, time != "hour 2")
  
  # Dividir el dataset por grupos únicos de 'infection' + 'agent'
  filtered$group <- interaction(filtered$infection, filtered$agent)
  
  # Seleccionar 4 muestras al azar de cada grupo
  selected <- do.call(rbind, lapply(split(filtered, filtered$group), function(group_data) {
    if (nrow(group_data) > 4) {
      group_data[sample(1:nrow(group_data), 4), ]
    } else {
      group_data
    }
  }))
  
  # Obtener los índices originales como nombres de las filas seleccionadas
  original_indices <- match(selected$sample, allTargets$sample)
  
  # Modificar los rownames usando 'sample' y los índices originales
  rownames(selected) <- paste0(selected$sample, ".", original_indices)
  
  # Eliminar la columna 'group' y devolver el resultado
  selected$group <- NULL
  return(selected)
}

# Obtenemos nuevo dataframe con los datos filtrados

targetsDF <- filter_microarray(allTargets, seed=52904568)
str(targetsDF)

# Creamos un objeto AnnotatedDataFrame

targets <- AnnotatedDataFrame(targetsDF)
targets

# Definimos algunas variables 

sampleInfection <- as.character(targetsDF$infection)
sampleTime <- as.character (targetsDF$time)
sampleAgent <- as.character(targetsDF$agent)

