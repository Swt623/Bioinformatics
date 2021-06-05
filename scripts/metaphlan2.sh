#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=metaphlan2-KM101

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 12:00:00 # Runtime in HH:MM:SS
#SBATCH -p genomicsguest

#SBATCH --mem=48G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/metaphlan2_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/metaphlan2_%A_%a.err

# purge all modules
module purge all

# load needed modules
module load singularity

# get name list for job array
# cd /projects/p31421/MonkeyGut
# names=($(cat MergedSample))
# echo "Processing ${names[${SLURM_ARRAY_TASK_ID}]} started."

sample="KM-101"
echo "Metaphlan2 ${sample} started."

cd /projects/b1042/HartmannLab/weitao/monkeygut/
# run Metaphlan2 in Singularity
singularity exec -B /projects/b1042/ -B /projects/b1057/ /projects/b1057/biobakery_diamondv0822.sif metaphlan2.py kneaddata_out/${sample}_R1_kneaddata_paired_1.fastq.gz,kneaddata_out/${sample}_R1_kneaddata_paired_2.fastq.gz --input_type fastq --bowtie2out ${sample}.bowtie2.bz2 --nproc 24 > metaphlan2_out/profiled_${sample}.txt

echo "Completed Metaphlan2 ${sample}."
