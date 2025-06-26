# Galaxy settings start ---------------------------------------------------

# setup R error handling to go to stderr
options(show.error.messages = F, error = function() {cat(geterrmessage(), file = stderr()); q("no", 1, F)})

# we need that to not crash galaxy with an UTF8 error on German LC settings.
loc <- Sys.setlocale("LC_MESSAGES", "en_US.UTF-8")

# Galaxy settings end -----------------------------------------------------

# Load packages -----------------------------------------------------------

suppressPackageStartupMessages({
    library(dplyr)
    library(ggplot2)
    library(ggrepel)
})


# Import data  ------------------------------------------------------------

# Auto-detect header by checking if P value column is numeric or not
first_line <- read.delim('/corral4/main/objects/e/f/1/dataset_ef182433-815e-42ba-b23c-e00ab8f47196.dat', header = FALSE, nrow = 1)
first_pvalue <- first_line[, 3]
if (is.numeric(first_pvalue)) {
  print("No header row detected")
  results <- read.delim('/corral4/main/objects/e/f/1/dataset_ef182433-815e-42ba-b23c-e00ab8f47196.dat', header = FALSE)
} else {
  print("Header row detected")
  results <- read.delim('/corral4/main/objects/e/f/1/dataset_ef182433-815e-42ba-b23c-e00ab8f47196.dat', header = TRUE)
}

# Format data  ------------------------------------------------------------

# Create columns from the column numbers specified and use the existing category_symbol column for shapes
results <- results %>% mutate(
    fdr = .[[2]],
    pvalue = .[[3]],
    logfc = .[[4]],
    labels = .[[1]],
)

# Check if shape_col is provided 

# Get names for legend
down <- unlist(strsplit('Downregulated,Not Significant,Upregulated', split = ","))[1]
notsig <- unlist(strsplit('Downregulated,Not Significant,Upregulated', split = ","))[2]
up <- unlist(strsplit('Downregulated,Not Significant,Upregulated', split = ","))[3]

# Set colours
colours <- setNames(c("cornflowerblue", "grey", "firebrick"), c(down, notsig, up))

# Create significant (sig) column
results <- mutate(results, sig = case_when(
                                fdr < 0.05 & logfc > 1.722 ~ up,
                                fdr < 0.05 & logfc < -1.722 ~ down,
                                TRUE ~ notsig))


# Specify genes to label --------------------------------------------------

# Get top genes by P value
top <- slice_min(results, order_by = pvalue, n = 10)

# Extract into vector
toplabels <- pull(top, labels)

# Label just the top genes in results table
results <- mutate(results, labels = ifelse(labels %in% toplabels, labels, ""))


# Create plot -------------------------------------------------------------

# Open file to save plot as PDF
pdf("volcano_plot.pdf")

# Set up base plot with faceting by category_symbol instead of shapes
p <- ggplot(data = results, aes(x = logfc, y = -log10(pvalue))) +
    scale_color_manual(values = colours) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(colour = "black"),
          legend.key = element_blank()) 

# Conditional logic to use either shape or facet based on user selection
p <- p + geom_point(aes(colour = sig)) #only add color

# Add gene labels
p <- p + geom_label_repel(data = filter(results, labels != ""), aes(label = labels),
                          min.segment.length = 0,
                          max.overlaps = Inf,
                          show.legend = FALSE)


p <- p + xlab('Grau de expressao (log(Z))')

p <- p + ylab('Significancia (-log10(p))')



# Set legend title
p <- p + guides(color = guide_legend(title = 'Legenda'))

# Print plot
print(p)

# Close PDF graphics device
dev.off()


# R and Package versions -------------------------------------------------
sessionInfo()