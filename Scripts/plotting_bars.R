library(ggplot2)
library(dplyr)
library(tidyr)
library(RColorBrewer)

cc <- read.csv("CC_analysis.csv", sep = "\t")
bp <- read.csv("BP_analysis.csv", sep = "\t")

ggplot(data = cc, aes(x=Term, y=Count, fill=Term)) +
  geom_bar(stat='identity') + scale_fill_brewer(palette="Blues") +
  labs(x="Componente celular", y="Número de genes") +
  theme(axis.text.x = element_blank())

ggsave("Componente celular.pdf")

ggplot(data = bp, aes(x=Term, y=Count, fill=Term)) + geom_bar(stat='identity') +
  scale_fill_brewer(palette="Blues") +
  labs(x="Processo biológico", y="Número de genes") +
  theme(axis.text.x = element_blank())

ggsave("Processo biológico.pdf")


