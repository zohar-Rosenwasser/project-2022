#!/bin/bash
# zohar rosenwasser 
# This program takes as input the 1: ds name, 2: chromosome, 3:starting position of the first alu,  4:final position of the second alu,
# 5: strand of the gene, 6: adonsine position file. The program runs known for all the samples in each of the tissue
# of the gtex database. After that produces an output to a csv file and a shape file.

ds_name=$1
chr=$2
start=$3
end=$4
strand=$5
pos_a_file="pos_a_${chr}_${start}_${end}.csv"

cd /private7/projects/zohar/alu/pos_A/
tr ',' '\t' < $pos_a_file > "pos_a_${chr}_${start}_${end}.bed"
cat "pos_a_${chr}_${start}_${end}.bed" | cut -f1-3 | sort -k1,1 -k2,2n > "pos_a_${chr}_${start}_${end}_sort.bed"
sort_pos_a="/private7/projects/zohar/alu/pos_A/pos_a_${chr}_${start}_${end}_sort.bed"

cd /private9/Datasets/GTEx/BamLinksWithHyperEditedReads/
for tissue in $(ls)
	do 
IN_DIR="/private9/Datasets/GTEx/BamLinksWithHyperEditedReads/${tissue}/" 
OUT_DIR="/private7/projects/zohar/alu/ds_alu_REDIToolsKnown/${ds_name}/${tissue}"
suffix="_0.05_0.6_30_0.6_0.1_0.8_0.2.sortedByCoord.out.bam" #"Aligned.sortedByCoord.out.bam"
REGIOUNS=$sort_pos_a
mkdir -p $OUT_DIR 
python /home/alu/hillelr/scripts/GGPS/Session/PipelineManger.py -c /home/alu/hillelr/scripts/GGPS/PipelineConfigs/REDIToolsknownPipeline.conf -d $IN_DIR -f .bam -a known_sites_bed=\'${REGIOUNS}\' aligner_bam_suffix=\'$suffix\' min_reads_coverage=\'5\' BAM_dir=\'\%\(input_dir\)s\' -o $OUT_DIR -l $OUT_DIR >> ${OUT_DIR}/known.out


# combind known output 
IN_DIR="/private7/projects/zohar/alu/ds_alu_REDIToolsKnown/${ds_name}/${tissue}" 
OUT_DIR="/private7/projects/zohar/alu/ds_alu_REDIToolsKnown/${ds_name}/${tissue}"
Rscript /home/alu/fulther/Scripts/scripts_R/General/processREDItoolsKnown.R -i $IN_DIR -o $OUT_DIR --min_coverage 5

# Union by position
python "/private7/projects/zohar/alu/REDToolKnown.py" "/private7/projects/zohar/alu/ds_alu_REDIToolsKnown/${ds_name}/${tissue}/REDItoolKnown.out.combined.csv" "/private7/projects/zohar/alu/ds_alu_REDIToolsKnown/${ds_name}/${tissue}/REDItoolKnown.out.combinedAll.csv"

# create shape file 
python "/private7/projects/zohar/alu/create_shape_file.py" "/private7/projects/zohar/alu/ds_alu_REDIToolsKnown/${ds_name}/${tissue}/REDItoolKnown.out.combinedAll.csv" "/private7/projects/zohar/alu/ds_alu_REDIToolsKnown/${ds_name}/${tissue}/${tissue}_position_for_shape.csv" $start $end $strand

tr ',' '\t' < "/private7/projects/zohar/alu/ds_alu_REDIToolsKnown/${ds_name}/${tissue}/${tissue}_position_for_shape.csv" > "/private7/projects/zohar/alu/ds_alu_REDIToolsKnown/${ds_name}/${tissue}/${tissue}_position_for_shape.shape"

	done
