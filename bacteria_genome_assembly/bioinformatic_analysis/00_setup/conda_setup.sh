#Here is a script to set up the environment such that it will work with the nanopore pipelines I have developed. 

#Environment for assembly
conda env create -n assembly
conda activate assembly
conda install -c bioconda flye
conda deactivate

#Environment for medakka, this was a massive pain when troubleshooting install
conda env create -n medakka
conda activate medakka
conda install -c anaconda python=3.9
# Once you do this, as of 2Feb2023, you need to manually modify source to prevent a unicode error as described here https://github.com/nanoporetech/medaka/issues/404 
pip install medaka
conda deactivate

#Installing Prokka for genome annotation, there was something funny about this, need to go back and look at what it was. 
conda env create -n prokka
conda activate prokka
conda deactivate prokka

#Installing seqkit to parse read length information from each fasta file. 
conda env create -n nanopore_stats
conda activate nanopore_stats
conda install -c bioconda seqkit
conda deactivate 

# Also, I needed to install quarto

# This I did by downloading the deb file from here: https://quarto.org/docs/get-started/

