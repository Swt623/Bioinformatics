#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=fastqc-loop

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 24:00:00 # Runtime in D-HH:MM
#SBATCH -p genomicsguest

#SBATCH --mem=24G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/greywater/job_files/fastqc_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/greywater/job_files/fastqc_%A_%a.err

# purge all modules
module purge all

# load needed modules
module load fastqc/0.11.5

# get name list for raw data
cd /projects/b1042/HartmannLab/weitao/greywater/sequence
raw1=($(cat sample_names1.txt))
raw2=($(cat sample_names2.txt))

cd /projects/b1042/HartmannLab/weitao/greywater/kneaddata_out
qc1=($(cat kneaddata_out_names1.txt))
qc2=($(cat kneaddata_out_names2.txt))
# sample=($(cat kneaddata_out_samples.txt))

# loop over name list
cd /projects/b1042/HartmannLab/weitao/greywater
for i in {0..11}
do
# run 
  fastqc sequence/${raw1[$i]} -o fastqc_out/
  fastqc sequence/${raw2[$i]} -o fastqc_out/
  fastqc kneaddata_out/${qc1[$i]} -o fastqc_out/
  fastqc kneaddata_out/${qc2[$i]} -o fastqc_out/
done
