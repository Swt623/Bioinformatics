#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=metaxa2

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 04:00:00 # Runtime in D-HH:MM
#SBATCH -p genomics

#SBATCH --mem=0
#SBATCH --output=/projects/b1042/HartmannLab/weitao/greywater/job_files/metaxa2_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/greywater/job_files/metaxa2_%A_%a.err
#SBATCH --array=0-9 # job array index 

# purge all modules
module purge all

# load needed modules

module load metaxa2/2.2
module load blast/2.7.1

# get name list for job array
cd /projects/b1042/HartmannLab/weitao/greywater/kneaddata_out_decontaminate/
sample1=($(cat sample1.txt))
sample2=($(cat sample2.txt))
sample=($(cat SampleNames.txt))

# convert fastq to fasta
#sed -n '1~4s/^@/>/p;2~4p' ${sample1[${SLURM_ARRAY_TASK_ID}]}.fastq > ${sample1[${SLURM_ARRAY_TASK_ID}]}.fasta

#sed -n '1~4s/^@/>/p;2~4p' ${sample2[${SLURM_ARRAY_TASK_ID}]}.fastq > ${sample2[${SLURM_ARRAY_TASK_ID}]}.fasta

# run metaxa2
metaxa2 -1 ${sample1[${SLURM_ARRAY_TASK_ID}]}.fasta -2 ${sample2[${SLURM_ARRAY_TASK_ID}]}.fasta -o ../metaxa2_out_decontaminate/${sample[${SLURM_ARRAY_TASK_ID}]} --cpu 24 --align none --plus T

echo "Completed Metaxa2 "${sample[${SLURM_ARRAY_TASK_ID}]}

cd /projects/b1042/HartmannLab/weitao/greywater/metaxa2_out_decontaminate/

# run metaxa2_ttt
metaxa2_ttt -i ${sample[${SLURM_ARRAY_TASK_ID}]}.taxonomy.txt -o ../metaxa2_ttt_decontaminate/${sample[${SLURM_ARRAY_TASK_ID}]}

# run metaxa2_rf
metaxa2_rf -i ${sample[${SLURM_ARRAY_TASK_ID}]}.taxonomy.txt -o ../metaxa2_rf_decontaminate/${sample[${SLURM_ARRAY_TASK_ID}]} --separate F

echo "Completed metaxa2 output analysis for sample ${sample[${SLURM_ARRAY_TASK_ID}]}."

