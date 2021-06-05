#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=metaxa2-test1

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 12:00:00 # Runtime in D-HH:MM
#SBATCH -p genomicsguest

#SBATCH --mem=0
#SBATCH --output=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/metaxa2_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/metaxa2_%A_%a.err
#SBATCH --array=0 # job array index 

# purge all modules
module purge all

# load needed modules
#module load singularity
module load metaxa2/2.2
module load blast/2.7.1

export PATH:$PATH: /software/blast/ncbi-blast-2.7.1+/bin
#export PATH:$PATH:/software/metaxa2/2.2

# get name list for job array
cd /projects/b1042/HartmannLab/weitao/monkeygut/kneaddata_out/
names=($(cat SampleNames_paired.txt))

# convert second mate fastq.gz to fasta
gunzip -c ${names[${SLURM_ARRAY_TASK_ID}]}_R1_kneaddata_paired_2.fastq.gz | awk '{if(NR%4==1) {printf(">%s\n",substr($0,2));} else if(NR%4==2) print;}' > ${names[${SLURM_ARRAY_TASK_ID}]}_R1_kneaddata_paired_2.fasta

echo "Processing ${names[${SLURM_ARRAY_TASK_ID}]} started."

# run metaxa2
metaxa2 -1 /projects/b1042/HartmannLab/weitao/monkeygut/kneaddata_out/${names[${SLURM_ARRAY_TASK_ID}]}_R1_kneaddata_paired_1.fasta -2 /projects/b1042/HartmannLab/weitao/monkeygut/kneaddata_out/${names[${SLURM_ARRAY_TASK_ID}]}_R1_kneaddata_paired_2.fasta -o /projects/b1042/HartmannLab/weitao/monkeygut/metaxa2_out/${names[${SLURM_ARRAY_TASK_ID}]} --cpu 24 --align none --plus T

echo "Completed Metaxa2 "${names[${SLURM_ARRAY_TASK_ID}]}
