#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=Nonpareil_KM-149

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 24:00:00
#SBATCH -p genomicsguest

#SBATCH --mem=0
#SBATCH --output=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/Nonpareil_KM-10_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/Nonpareil_KM-10_%A_%a.err

module purge all
module load python-anaconda3
# create environment for nonpareil
conda create -n nonpareil -c bioconda nonpareil
# load the new environment into PATH
source activate nonpareil

name="KM-149"

echo "Processing ${name} paired R1 Nonpareil started."

# go to directory for the samples
cd /projects/b1042/HartmannLab/weitao/monkeygut/kneaddata_out

# transform from fastq.gz to fasta for Nonpareil
gunzip -c ${name}_R1_kneaddata_paired_1.fastq.gz | awk '{if(NR%4==1) {printf(">%s\n",substr($0,2));} else if(NR%4==2) print;}' > ${name}_R1_kneaddata_paired_1.fasta

# run nonpareil
nonpareil -s ${name}_R1_kneaddata_paired_1.fasta -T alignment -f fasta -b /projects/b1042/HartmannLab/weitao/monkeygut/nonpareil_out/${name}_paired_1 -t 24

echo "Completed Nonpareil ${name} paired R1."
