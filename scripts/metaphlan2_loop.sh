#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=metaphlan2-loop1-20

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=12 # Request that ncpus be allocated per process.

#SBATCH -t 12:00:00 # Runtime in HH:MM:SS
#SBATCH -p genomicsguest

#SBATCH --mem=16G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/metaphlan2_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/metaphlan2_%A_%a.err

# purge all modules
module purge all

# load needed modules
module load singularity

# get name list for job array
cd /projects/b1042/HartmannLab/weitao/monkeygut/kneaddata_out/
names=($(cat SampleNames_paired.txt))

echo "Processing 1-20 samples."

cd /projects/b1042/HartmannLab/weitao/monkeygut/

# loop over name list
for i in {1..20}
do
  echo "Metaphlan2 ${names[$i]} started."

# run Metaphlan2 in Singularity
  singularity exec -B /projects/b1042/ -B /projects/b1057/ /projects/b1057/biobakery_diamondv0822.sif metaphlan2.py kneaddata_out/${names[$i]}_R1_kneaddata_paired_1.fastq.gz,kneaddata_out/${names[$i]}_R1_kneaddata_paired_2.fastq.gz --input_type fastq --bowtie2out metaphlan2_out/${names[$i]}.bowtie2.bz2 --nproc 12 > metaphlan2_out/profiled_${names[$i]}.txt

  echo "Completed Metaphlan2 ${names[$i]}."
done
