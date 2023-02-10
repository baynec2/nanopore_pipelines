#update these variables for your specific study
npstudy=NP001_all_reads_combined_assembly
nanopore_run_directory=~/nanopore_assembly/NP001_all_reads_combined
barcode_numbers=({01..13})
barcodes=( "${barcode_numbers[@]/#/barcode}")
outdir=~/nanopore_assembly/$npstudy
reference_fasta=~/nanopore_analysis/NP001_strep/Streptococcus_pneumoniae_ATCC_BAA_334.fasta

#activating the right conda environment containing medaka for downstrea
conda activate medaka  
#looping through each of the barcodes from the run and calling variants. 
for i in ${barcodes[@]}
  do 
  #variant calling with medaka_haploid_variant
  medaka_haploid_variant -i $outdir/$i.fastq.gz -r $reference_fasta -o $outdir/flye_out/$i/medaka_variant/
done 