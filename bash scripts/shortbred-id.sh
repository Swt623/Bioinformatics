
#SBATCH -A b1042
#SBATCH --job-name=shortbred-id

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 12:00:00 # Runtime in HH:MM:SS
#SBATCH -p genomics

#SBATCH --mem=96G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/greywater/job_files/shortbred-id_%A.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/greywater/job_files/shortbred-id_%A.err

# purge all modules
module purge all

cd /projects/b1042/HartmannLab/weitao/shortbred_card/card-data-2021-07/

## merge the card protein files (4 total)
cat protein_fasta_protein_homolog_model.fasta protein_fasta_protein_knockout_model.fasta protein_fasta_protein_overexpression_model.fasta protein_fasta_protein_variant_model.fasta > CARD_proteins_merged.fasta

## load modules for accessing biobakery tools (at NU, this is run on singularity container)
module load singularity

## run shortbred identify to build CARD marker set with reference to uniref90
gunzip ../../uniref_db/uniref90.fasta.gz

singularity exec -B /projects/b1042/ -B /projects/b1057/ /projects/b1057/biobakery_diamondv0822.sif shortbred_identify.py --threads 24 --goi CARD_proteins_merged.fasta --ref ../../uniref_db/uniref90.fasta --markers CARD_markers_u90.faa --tmp tmpdir

gzip ../../uniref_db/uniref90.fasta

