#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=humann2-KM101

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=12 # Request that ncpus be allocated per process.

#SBATCH -t 4:00:00 # Runtime in HH:MM:SS
#SBATCH -p genomicsguest

#SBATCH --mem=12G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/metaphlan2_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/metaphlan2_%A_%a.err

# purge all modules
module purge all

# load needed modules
module load singularity

sample="KM-101"
echo "HUMAnN2 ${sample} started."

cd /projects/b1042/HartmannLab/weitao/monkeygut/
# run HUMAnN2 in Singularity
singularity exec -B /projects/b1042/ -B /projects/b1057/ /projects/b1057/biobakery_diamondv0822.sif humann2 -i metaphlan2_out/${sample}.bowtie2.bz2 -o humann2_out --input-format sam --threads 12

echo "Completed HUMAnN2 ${sample}."
