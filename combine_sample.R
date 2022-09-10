
df_all_sample <- read.csv("/private7/projects/zohar/alu/ds_alu_REDIToolsKnown/chr4_2938248_2938792/REDItoolKnown.out.combined_all_tissue_chr4_2938248_2938792.csv", header=TRUE, stringsAsFactors=FALSE)

df_all_sample$SampleId <- ""
sample <- unlist(sample <- str_split(df_all_sample$Sample[1], "-"))[3]

for (row in 1:nrow(df_all_sample)) {
  sample <- unlist(sample <- str_split(df_all_sample$Sample[row], "-"))[3]
  df_all_sample$SampleId[row] <- sample
}

write.csv(df_all_sample,"/private7/projects/zohar/alu/ds_alu_REDIToolsKnown/chr4_2938248_2938792/REDItoolKnown.out.combined_all_tissue_Sample_chr4_2938248_2938792.csv", row.names = FALSE)

pos_a <- read.csv("/private7/projects/zohar/alu/pos_A/pos_a_chr4_2938248_2938792.csv", header=TRUE, stringsAsFactors=FALSE)

list_sample<-df_all_sample %>%
  distinct(SampleId) %>%
  pull(SampleId) %>%
  as.list

combine_sample <- pos_a

for (sample in list_sample) {
  sample_data <- df_all_sample %>% filter(SampleId == sample)
  combine_sample[, sample] = ""
  for (pos in 1:nrow(pos_a)) {
  A_pos <- pos_a$Position[pos]
  pos_data  <- sample_data %>% filter(Position == A_pos)
  if (nrow(pos_data) == 0) {
    Frequency <- 'NA'
    next
  }
  Coverage <- sum(pos_data$CoverageAG)
  if (Coverage < 20) {
    Frequency <- 'NA'
  }
  A <- sum(pos_data$A)
  G <- sum(pos_data$G)
  Frequency <- G / (A + G)
  combine_sample[, sample][pos] = Frequency
  }
}

write.csv(combine_sample,"/private7/projects/zohar/alu/ds_alu_REDIToolsKnown/chr4_2938248_2938792/combined_all_Sample_chr4_2938248_2938792.csv", row.names = FALSE)

combine_sample_for_cor <- read.csv("/private7/projects/zohar/alu/ds_alu_REDIToolsKnown/chr4_2938248_2938792/combined_all_Sample_chr4_2938248_2938792.csv", header=TRUE, stringsAsFactors=FALSE)

combine_sample_for_cor <- combine_sample_for_cor %>% select(-Chr, -Strand)
rownames(combine_sample_for_cor) <- combine_sample_for_cor$Position
combine_sample_for_cor <- combine_sample_for_cor %>% select(-Position)
combine_sample_for_cor <- t(combine_sample_for_cor)
combine_sample_for_cor <- na.omit(combine_sample_for_cor) 
combine_sample_for_cor <- t(combine_sample_for_cor)


fit <- kmeans(combine_sample_for_cor, 4)
# get cluster means
aggregate(combine_sample_for_cor,by=list(fit$cluster),FUN=mean)
cluster1 <- fit$cluster
# append cluster assignment
mydata <- data.frame(combine_sample_for_cor, fit$cluster)



cor_sample <- cor(combine_sample_for_cor, use = "complete.obs")
cor_sample <- rcorr((combine_sample_for_cor))
out <- corrplot(cor_sample,  method = 'color',order = 'hclust', tl.cex = 0.1)




melted_cormat <- melt(cor_sample)
ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()


