# Load packages:
library(ggplot2)
library(gggenes)
library(dplyr)
library("gridExtra")
library(patchwork)

#### This file plot gene diagrams for the top ranked RepSeqs of each selected cloning target.
# Set working dirctory
setwd('~/OneDrive - Northwestern University/Hartmann Lab/Mosaic Ends Tagmentation/Sequencing_Data_Analysis/Cloning_Targets')

# Read in data
# Total number of Rep Seqs = 21
genes <- read.table('TopRepSeq_with_Targets.tsv', sep = '\t', quote = "", header = TRUE)
# Get a dataframe with Rep Seqs ID, Rep.Seq.Cluster.Size, and Rep Seq source as the columns.
repseqs <- genes %>% select(feature,Rep.Seq.Cluster.Size,sample) %>% distinct()

# Sort the Rep Seqs dataframe by their source sample name:
ordered_repseqs <- repseqs[order(repseqs$sample), ]
# Get the ordered list of Rep Seq IDs:
ordered_feature <- ordered_repseqs$feature

# Sort the Rep Seqs (feature) column of `genes` and
# `repseqs` dataframes by `ordered_feature`.
# `repseqs` needs to be ordered reversely b/c the heatmap is plotted bottom-up. 
genes$feature <- factor(genes$feature, levels = ordered_feature)
repseqs$feature <- factor(repseqs$feature, levels = rev(ordered_feature))

# Make gene diagram
gene_diagram <- ggplot(genes, aes(xmin = start, xmax = end, y = feature, fill = product, label = ARG_target)) +
  geom_gene_arrow() +
  geom_gene_label(align = "centre",grow=T) +
  facet_wrap(~ feature, scales = "free", ncol = 1) +
  scale_fill_brewer(palette = "Set3") +
  theme_genes() + 
  labs(y="Rep Seq ID") +
  theme(legend.position = "bottom",
        legend.key.size = unit(15, "pt"),
        plot.margin = margin(12, 0, 0, 0, unit = "pt")) +
  guides(fill=guide_legend(ncol=2,byrow=TRUE))

# Create the one-column heatmap of the Rep Seq Cluster Size
heatmap <- ggplot(repseqs, aes(x = 1, 
                               y = feature, 
                               fill = Rep.Seq.Cluster.Size)) +
  geom_tile(color = "black", size = 1) +
  labs(x="Rep Seq Cluster Size",y="") +
  scale_fill_gradient(low = "white", high = "red") +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),
        axis.text.y = element_blank(), axis.ticks.y = element_blank(),
        legend.position = "bottom", legend.margin = margin(t = 0, unit = "line"),
        legend.title = element_blank(),
        plot.margin = margin(0, 0, 65, 0, unit = "pt")) #top, right, bottom, left

# Create the one-column heatmap of the Rep Seq source (`sample`)
heatmap_sample <- ggplot(repseqs, 
                         aes(x = 1, y = feature, fill = sample)) +
  geom_tile(color = "black", size = 1) +
  geom_text(aes(label = sample), color = "black") +  # Add text labels to cells
  scale_fill_discrete() +  # Use discrete colors for categorical values
  labs(x="Rep Seq Source",y="") +
  #labs(title = "One-Column Heatmap with Categorical Color Fill") +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), # Hide axis labels and ticks
        axis.ticks.y = element_blank(), axis.text.y = element_blank(),
        legend.position = "none", # Hide legend
        plot.margin = margin(0, 0, 108, 0, unit = "pt")) # Set plot bottom margin to align plots vertically

#### Combine three plots and save as .pdf file.
pdf(file = 'TopRepSeq_with_Targets_GeneDiagram.pdf',
    width = 20, height = 10) # Set figure size

combined_plots <- grid.arrange(gene_diagram, heatmap, heatmap_sample, 
                               ncol = 3,  # Set number of columns
                               widths = c(3, 0.4, 0.4)) # Set the width of each figure
dev.off()