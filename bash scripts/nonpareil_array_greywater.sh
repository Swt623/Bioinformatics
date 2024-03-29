#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=Nonpareil-greywater

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 06:00:00 # Runtime in D-HH:MM
#SBATCH -p genomics

#SBATCH --mem=4G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/greywater/job_files/Nonpareil_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/greywater/job_files/Nonpareil_%A_%a.err
#SBATCH --array=0-9 # job array index 

module purge all
module load python-anaconda3
source activate nonpareil

# get name list for job array
# go to directory for the samples
cd /projects/b1042/HartmannLab/weitao/greywater/kneaddata_out_decontaminate/
sample1=($(cat sample1.txt))
sample=($(cat SampleNames.txt))

echo "Processing ${sample1[${SLURM_ARRAY_TASK_ID}]} Nonpareil started."

# run nonpareil
nonpareil -s ${sample1[${SLURM_ARRAY_TASK_ID}]}.fasta -T alignment -f fasta -b ../nonpareil_out2/${sample[${SLURM_ARRAY_TASK_ID}]} -t 24

echo "Completed Nonpareil ${sample1[${SLURM_ARRAY_TASK_ID}]}."
