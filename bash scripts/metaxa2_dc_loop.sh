#!/bin/bash

#SBATCH -A p31421
#SBATCH --job-name=metaxa2-dc

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH -t 00:10:00 # Runtime in D-HH:MM:SS
#SBATCH -p short

#SBATCH --mem=1G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/greywater/job_files/metaxa2_%A.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/greywater/job_files/metaxa2_%A.err

# purge all modules
module purge all

# load needed modules
module load metaxa2/2.2
module load blast/2.7.1

cd /projects/b1042/HartmannLab/weitao/greywater/metaxa2_ttt_decontaminate/

# loop over levels 1-9
for i in {1..9}
do
# run metaxa2_dc
  metaxa2_dc -o ../metaxa2_dc/taxomony_all_level_${i}.txt *level_${i}.txt
  echo "Collected metaxa2 output for level ${i}."
done


