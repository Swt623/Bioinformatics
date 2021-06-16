#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=Nonpareil_36-99

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 10:00:00 # Runtime in D-HH:MM
#SBATCH -p genomics

#SBATCH --mem=12G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/Nonpareil_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/Nonpareil_%A_%a.err
#SBATCH --array=36-99%10 # job array index 

module purge all
module load python-anaconda3
# create environment for nonpareil
conda create -n nonpareil -c bioconda nonpareil
# load the new environment into PATH
source activate nonpareil

# get name list for job array
cd /projects/p31421/MonkeyGut
names=($(cat MergedSample))

echo "Processing ${names[${SLURM_ARRAY_TASK_ID}]} paired R1 Nonpareil started."

# go to directory for the samples
cd /projects/b1042/HartmannLab/weitao/monkeygut/kneaddata_out

# transform from fastq.gz to fasta for Nonpareil
gunzip -c ${names[${SLURM_ARRAY_TASK_ID}]}_R1_kneaddata_paired_1.fastq.gz | awk '{if(NR%4==1) {printf(">%s\n",substr($0,2));} else if(NR%4==2) print;}' > ${names[${SLURM_ARRAY_TASK_ID}]}_R1_kneaddata_paired_1.fasta

# run nonpareil
nonpareil -s ${names[${SLURM_ARRAY_TASK_ID}]}_R1_kneaddata_paired_1.fasta -T alignment -f fasta -b /projects/b1042/HartmannLab/weitao/monkeygut/nonpareil_out/${names[${SLURM_ARRAY_TASK_ID}]}_paired_1 -t 24

echo "Completed Nonpareil ${names[${SLURM_ARRAY_TASK_ID}]} paired R1."
