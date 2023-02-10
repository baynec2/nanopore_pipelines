#update these variables for your specific study
npstudy=NP001_all_reads_combined_assembly
nanopore_run_directory=~/nanopore_assembly/NP001_all_reads_combined
barcode_numbers=({01..15})
barcodes=( "${barcode_numbers[@]/#/barcode}")
outdir=~/nanopore_assembly/$npstudy


#activating the right conda environment containing flye
conda activate assembly 

mkdir $outdir
#looping through each of the barcodes from the run and doing a flye assembly. 
#if it does not run correctly due to too high read depth the flags --asm-coverage 150 --genome-size n will fix it. 
for i in ${barcodes[@]}
  do 
  mkdir $outdir/flye_out/$i -p 
  cat $nanopore_run_directory/$i/*.fastq.gz > $outdir/$i.fastq.gz
  flye --nano-raw $outdir/$i.fastq.gz --out-dir $outdir/flye_out/$i --threads 20 
done 

# Polishing with medaka, note for install I had to instal python=3.9 and pip install medaka to get it to work right.
# then I had to modify source see here: https://github.com/nanoporetech/medaka/issues/404 
conda deactivate
conda activate medaka
# changing to allow for GPU use according to docs. I can't get it to run on GPU as of 31Jan2023. 
export TF_FORCE_GPU_ALLOW_GROWTH=true
for i in ${barcodes[@]}
  do 
  mkdir  $outdir/flye_out/$i/medaka_consensus/
  medaka_consensus -i $outdir/$i.fastq.gz -d $outdir/flye_out/$i/assembly.fasta -o $outdir/flye_out/$i/medaka_consensus/ -t 20 -m r1041_e82_260bps_hac_g632 -b 70
done

# Adding a barcode name to fasta header of each assembly
for i in ${barcodes[@]}
  do 
  sed "s/>/>$i\//I" $outdir/flye_out/$i/medaka_consensus/consensus.fasta > $outdir/flye_out/$i/medaka_consensus/consensus.named.fasta
done

# Annotating with prokka
conda deactivate
conda activate prokka
for i in ${barcodes[@]}
  do 
  prokka $outdir/flye_out/$i/medaka_consensus/consensus.fasta --outdir $outdir/flye_out/$i/medaka_consensus/prokka
done

# Going back and adding bandage visulization of assembly graph for all files
conda deactivate
for i in ${barcodes[@]}
  do 
 ~/Desktop/Bandage image $outdir/flye_out/$i/assembly_graph.gfa  $outdir/flye_out/$i/assembly_graph.jpg 
done

conda activate nanopore_stats
# Adding file with read length information for each barcode
for i in ${barcodes[@]} 
  do 
  seqkit fx2tab -nl $outdir/$i.fastq.gz > $outdir/$i.readlength.txt
done

#Rendering the final input
quatro render ~/nanopore_assembly/nanopore_report_template.qmd -P $npstudy

#Moving the rendered report to the final location
mv ~nanopore_assembly/nanopore_report_template.html $outdir/nanopore_report_template.html