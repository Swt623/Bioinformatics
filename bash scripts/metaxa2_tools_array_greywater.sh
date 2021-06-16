#!/bin/bash

#SBATCH -A p31421
#SBATCH --job-name=metaxa2-ttt_rf

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1

#SBATCH -t 4:00:00 # Runtime in D-HH:MM
#SBATCH -p normal

#SBATCH --mem=12G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/greywater/job_files/metaxa2_ttt_rf_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/greywater/job_files/metaxa2_ttt_rf_%A_%a.err
#SBATCH --array=0-11 # job array index 

# purge all modules
module purge all

# load needed modules
module load metaxa2/2.2
module load blast/2.7.1

# get name list for job array
cd /projects/b1042/HartmannLab/weitao/greywater/metaxa2_out
sample=($(cat metaxa2_out_samples.txt))

# run metaxa2_ttt
metaxa2_ttt -i ${sample[${SLURM_ARRAY_TASK_ID}]}.taxonomy.txt -o ../metaxa2_ttt/${sample[${SLURM_ARRAY_TASK_ID}]}

# run metaxa2_rf
metaxa2_rf -i ${sample[${SLURM_ARRAY_TASK_ID}]}.taxonomy.txt -o ../metaxa2_rf/${sample[${SLURM_ARRAY_TASK_ID}]} --separate F

echo "Completed metaxa2 output analysis for sample ${sample[${SLURM_ARRAY_TASK_ID}]}."
