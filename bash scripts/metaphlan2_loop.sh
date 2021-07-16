#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=metaphlan2-loop

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=12 # Request that ncpus be allocated per process.

#SBATCH -t 4:00:00 # Runtime in HH:MM:SS
#SBATCH -p genomics

#SBATCH --mem=4G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/metaphlan2_%A.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/metaphlan2_%A.err

# purge all modules
module purge all

# load needed modules
module load singularity

# get name list for job array
cd /projects/b1042/HartmannLab/weitao/greywater/kneaddata_out_decontaminate/
mate1=($(cat sample1.txt))
mate2=($(cat sample2.txt))
sample=($(cat SampleNames.txt))

echo "Processing 10 samples."

# loop over name list
for i in {0..9}
do
  echo "Metaphlan2 ${sample[$i]} started."

# run Metaphlan2 in Singularity
  singularity exec -B /projects/b1042/ -B /projects/b1057/ /projects/b1057/biobakery_diamondv0822.sif metaphlan2.py ${mate1[$i]}.fastq,${mate2[$i]}.fastq --input_type fastq --bowtie2out ../metaphlan2_out_decontaminate/${sample[$i]}.bowtie2.bz2 --nproc 12 > ../metaphlan2_out_decontaminate/profiled_${sample[$i]}.txt

  echo "Completed Metaphlan2 ${sample[$i]}."
done
