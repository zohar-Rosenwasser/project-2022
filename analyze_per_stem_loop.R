library(tidyverse)
library(hrbrthemes)
library(viridis)

# This program accepts as input the data for all adenosines in ds and produces graphs that display the data


df_combine_tissue <- read.csv("/private7/projects/zohar/alu/ds_alu_REDIToolsKnown/chr4_2938248_2938792/combined_all_tissue_with_seq_pair_loop_stem_chr4_2938248_2938792.csv", header=TRUE, stringsAsFactors=FALSE)
df_combine_tissue <- df_combine_tissue %>% filter(Pair != 'NAN')


# pair boxplot
df_combine_tissue %>%
  ggplot( aes(x=Pair, y=Frequency, fill=Pair)) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=11)
  ) +
  ggtitle("chr4_2938248_2938792") +
  xlab("")

# seq3base boxplot
df_combine_tissue %>%
  ggplot( aes(x=reorder(Seq3base,Frequency), y=Frequency, fill=Seq3base)) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=11)
  ) +
  ggtitle("chr4_2938248_2938792") +
  xlab("") + ylab("% editing")


df_combine_tissue$stem_loop = ""
if (!is.na(df_combine_tissue$stem)) {
  df_combine_tissue$stem_loop = "Stem"
}

for (row in 1:nrow(df_combine_tissue)) {
  if (!is.na(df_combine_tissue$stem[row])) {
    stem_loop <- "Stem"
  }
  else {
    stem_loop <- "Loop" 
  }
  df_combine_tissue$stem_loop[row] <- stem_loop
}

#stem loop
df_combine_tissue %>%
  ggplot( aes(x=stem_loop, y=Frequency, fill=stem_loop)) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=11)
  ) +
  ggtitle("chr4_2938248_2938792") +
  xlab("") + ylab("% editing")


ds_stem <- df_combine_tissue %>% filter(stem_loop == "Stem")
ds_loop <- df_combine_tissue %>% filter(stem_loop == "Loop")
ds_loop <- ds_loop %>% filter(Loop != 'NA')

ds_stem$stem <- as.factor(ds_stem$stem)

ds_stem %>%
  ggplot( aes(x=reorder(stem,Frequency), y=Frequency, fill = stem)) +
  geom_boxplot() +
  ggtitle(" stem size chr4_2938248_2938792") +
  xlab("") + ylab("% editing")

ds_loop %>%
  ggplot( aes(x=reorder(Loop,Frequency), y=Frequency, fill = Loop)) +
  geom_boxplot() +
  ggtitle(" Loop size chr4_2938248_2938792") +
  xlab("") + ylab("% editing")
