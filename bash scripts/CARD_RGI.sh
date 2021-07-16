#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=rgi

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 4:00:00 # Runtime in HH:MM:SS
#SBATCH -p genomics

#SBATCH --mem=8G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/greywater/job_files/rgi_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/greywater/job_files/rgi_%A_%a.err
#SBATCH --array=0-9 # job array index

# purge all modules
module purge all

# load needed modules
module load python-anaconda3/2019.10
source activate rgi

# load CARD database
cd /projects/b1042/HartmannLab/weitao/CARD_database

rgi load --card_json card.json
rgi load -i card.json --card_annotation card_database_v3.1.2.fasta
rgi load --wildcard_annotation wildcard_database_v3.1.2.fasta --wildcard_index wildcard/index-for-model-sequences.txt --card_annotation card_database_v3.1.2.fasta

# get sample names
cd /projects/b1042/HartmannLab/weitao/greywater/kneaddata_out_decontaminate/
sample1=($(cat sample1.txt))
sample2=($(cat sample2.txt))
sample=($(cat SampleNames.txt))

# convert fastq to fasta
#sed -n '1~4s/^@/>/p;2~4p' ${sample1[${SLURM_ARRAY_TASK_ID}]}.fastq > ${sample1[${SLURM_ARRAY_TASK_ID}]}.fasta
#sed -n '1~4s/^@/>/p;2~4p' ${sample2[${SLURM_ARRAY_TASK_ID}]}.fastq > ${sample2[${SLURM_ARRAY_TASK_ID}]}.fasta

# run RGI
rgi bwt -1 ${sample1[${SLURM_ARRAY_TASK_ID}]}.fastq -2 ${sample2[${SLURM_ARRAY_TASK_ID}]}.fastq -a bowtie2 -n 24 -o /projects/b1042/HartmannLab/weitao/greywater/CARD_out/${sample[${SLURM_ARRAY_TASK_ID}]} --clean --include_wildcard
