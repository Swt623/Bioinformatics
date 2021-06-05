#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=metaxa2-tools

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 24:00:00 # Runtime in D-HH:MM
#SBATCH -p genomicsguest

#SBATCH --mem=24G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/metaxa2_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/metaxa2_%A_%a.err

# purge all modules
module purge all

# load needed modules
#module load singularity
module load metaxa2/2.2
module load blast/2.7.1

export PATH:$PATH: /software/blast/ncbi-blast-2.7.1+/bin
#export PATH:$PATH:/software/metaxa2/2.2

# get name list for job array
cd /projects/b1042/HartmannLab/weitao/monkeygut/metaxa2_out
names=($(cat SampleNames_0527.txt))

# loop over name list
for i in {0..84}
do
  FILE=/projects/b1042/HartmannLab/weitao/monkeygut/metaxa2_out/${names[$i]}.taxonomy.txt
  if test -f "$FILE"
  then
# run metaxa2_ttt
    metaxa2_ttt -i ${names[$i]}.taxonomy.txt -o ../metaxa2_ttt_out/${names[$i]}
    metaxa2_rf -i ${names[$i]}.taxonomy.txt -o ../metaxa2_rf_out/${names[$i]} --separate F
  else
    echo "Sample ${names[$i]} does not exist."
  fi
done

echo "Completed metaxa2 output analysis for sample ${names[$i]}."
