#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=humann2-greywater

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 72:00:00 # Runtime in HH:MM:SS
#SBATCH -p genomicslong

#SBATCH --mem=96G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/greywater/job_files/humann2_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/greywater/job_files/humann2_%A_%a.err
#SBATCH --array=0-11 # job array index

# purge all modules
module purge all

# load needed modules
module load singularity

cd /projects/b1042/HartmannLab/weitao/greywater/kneaddata_out/

sample1=($(cat kneaddata_out_names1.txt))
sample2=($(cat kneaddata_out_names2.txt))
sample=($(cat kneaddata_out_samples.txt))

echo "HUMAnN2 ${sample[${SLURM_ARRAY_TASK_ID}]} started."

# cat ${sample1[${SLURM_ARRAY_TASK_ID}]}.fastq ${sample2[${SLURM_ARRAY_TASK_ID}]}.fastq > ../kneaddata_cat/${sample[${SLURM_ARRAY_TASK_ID}]}.fastq

# run HUMAnN2 in Singularity
cd /projects/b1042/HartmannLab/weitao/greywater/
singularity exec -B /projects/b1042/ -B /projects/b1057/ /projects/b1057/biobakery_diamondv0822.sif humann2 -i kneaddata_cat/${sample[${SLURM_ARRAY_TASK_ID}]}.fastq -o humann2_out --input-format fastq --threads 24 --taxonomic-profile metaphlan2_out/profiled_${sample[${SLURM_ARRAY_TASK_ID}]}.txt --nucleotide-database /projects/b1057/humann2_ref_data/chocophlan --protein-database /projects/b1057/humann2_ref_data/uniref50

echo "Completed HUMAnN2 ${sample[${SLURM_ARRAY_TASK_ID}]}."
