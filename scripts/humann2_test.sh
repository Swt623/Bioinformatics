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
#SBATCH --output=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/humann2_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/humann2_%A_%a.err

# purge all modules
module purge all

# load needed modules
module load singularity

sample="KM-101"
echo "HUMAnN2 ${sample} started."

cd /projects/b1042/HartmannLab/weitao/monkeygut/

cat kneaddata_out/${sample}_R1_kneaddata_paired_1.fastq.gz kneaddata_out/${sample}_R1_kneaddata_paired_2.fastq.gz > kneaddata_cat/${sample}.fastq.gz

# run HUMAnN2 in Singularity
singularity exec -B /projects/b1042/ -B /projects/b1057/ /projects/b1057/biobakery_diamondv0822.sif humann2 -i kneaddata_cat/${sample}.fastq.gz -o humann2_out --input-format fastq --threads 12 --taxonomic-profile metaphlan2_out/profiled_${sample}.txt --nucleotide-database /projects/b1057/humann2_ref_data/chocophlan --protein-database /projects/b1057/humann2_ref_data/uniref50

echo "Completed HUMAnN2 ${sample}."
