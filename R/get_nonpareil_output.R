## Load nonpareil library 
library(Nonpareil)

## get nonpareil output file names
files <- list.files(pattern = "\\.npo$") 
## sample labels
#>Sample_label <- c("","",…,"")

## make nonpareil curve for a set of samples
nps <- Nonpareil.set(files)

## save output from R Nonpareil
write.csv(print(nps), file="R-nonpareil-out.csv")
