#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=metaxa2-tools-KM115

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1

#SBATCH -t 10:00:00 # Runtime in D-HH:MM
#SBATCH -p genomicsguest

#SBATCH --mem=24G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/metaxa2_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/metaxa2_%A_%a.err

# purge all modules
module purge all

# load needed modules
module load metaxa2/2.2
module load blast/2.7.1

export PATH:$PATH: /software/blast/ncbi-blast-2.7.1+/bin
#export PATH:$PATH:/software/metaxa2/2.2

# get name list for job array
cd /projects/b1042/HartmannLab/weitao/monkeygut/metaxa2_out
name=KM-115


# run metaxa2_ttt
# metaxa2_ttt -i ${name}.taxonomy.txt -o ../metaxa2_ttt_out/${name}

# run metaxa2_rf
metaxa2_rf -i ${name}.taxonomy.txt -o ../metaxa2_rf_out/${name} --separate F

echo "Completed metaxa2 output analysis for sample ${name}."
