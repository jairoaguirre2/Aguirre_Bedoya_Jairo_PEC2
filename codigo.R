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
