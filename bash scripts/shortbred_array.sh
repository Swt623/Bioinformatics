#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=shortbred

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=24 # Request that ncpus be allocated per process.

#SBATCH -t 4:00:00 # Runtime in HH:MM:SS
#SBATCH -p genomics

#SBATCH --mem=12G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/greywater/job_files/shortbred_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/greywater/job_files/shortbred_%A_%a.err
#SBATCH --array=0-9 # job array index

# purge all modules
module purge all

# load needed modules
module load singularity

# go to files folder
cd /projects/b1042/HartmannLab/weitao/greywater/

# get sample names
sample1=($(cat kneaddata_out_decontaminate/Mate1.txt))

output=`echo ${sample1[${SLURM_ARRAY_TASK_ID}]} | cut -d "_" -f1,2,3`_sb.txt
tmpdir=`echo ${sample1[${SLURM_ARRAY_TASK_ID}]} | cut -d "_" -f1,2,3`_tmp_u90

# run shortbred in singularity 

singularity exec -B /projects/b1042/ -B /projects/b1057/ /projects/b1057/biobakery_diamondv0822.sif shortbred_quantify.py --threads 24 --markers ../CARD_database/card_markers_u90.faa --wgs kneaddata_out_decontaminate/${sample1[${SLURM_ARRAY_TASK_ID}]} --results shortbred/output/${output} --tmp shortbred/tmpdir/${tmpdir}
