#!/bin/bash

#SBATCH -A b1042
#SBATCH --job-name=Kneaddata_rerun

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1
#SBATCH --cpus-per-task=36 # Request that ncpus be allocated per process.

#SBATCH -t 12:00:00 # Runtime in D-HH:MM
#SBATCH -p genomicsguest

#SBATCH --mem=12G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/monkeygut/retry_kneaddata/Kneaddata_%A_%a.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/monkeygut/retry_kneaddata/Kneaddata_%A_%a.err
#SBATCH --array=0-15%8 # job array index 

# purge all modules
module purge all

# load needed modules
module load singularity

# get name list for job array
cd /projects/b1042/HartmannLab/weitao/monkeygut/
names=($(cat Failed_SampleNames.txt))
echo "Processing ${names[${SLURM_ARRAY_TASK_ID}]} started."

# run Kneaddata in Singularity
singularity exec -B /projects/b1042/ -B /projects/b1057/ -B /projects/p31421/ /projects/b1057/biobakery_diamondv0822.sif kneaddata --input /projects/b1057/shotgun_howlers/rerun_merged/${names[${SLURM_ARRAY_TASK_ID}]}_R1.fastq.gz --input /projects/b1057/shotgun_howlers/rerun_merged/${names[${SLURM_ARRAY_TASK_ID}]}_R2.fastq.gz --reference-db /projects/p31421/Database/AloPal --output /projects/b1042/HartmannLab/weitao/monkeygut/retry_kneaddata --threads 36

echo "Completed Kneaddata "${names[${SLURM_ARRAY_TASK_ID}]}

# Delete outputs
cd /projects/b1042/HartmannLab/weitao/monkeygut/retry_kneaddata/
rm decompressed*_${names[${SLURM_ARRAY_TASK_ID}]}_*.fastq
rm ${names[${SLURM_ARRAY_TASK_ID}]}_R1*trimmed*.fastq
rm ${names[${SLURM_ARRAY_TASK_ID}]}_R1*contam*.fastq

# Move and zip outputs
echo "Compressing ${names[${SLURM_ARRAY_TASK_ID}]} outputs to free up storage."

# mv ${names[${SLURM_ARRAY_TASK_ID}]}_R1_kneaddata_paired_*.fastq /projects/b1057/shotgun_howlers/merged_out/kneaddata_paired
# mv ${names[${SLURM_ARRAY_TASK_ID}]}_R1_kneaddata_unmatched_*.fastq /home/wse3132/MonkeyGut/kneaddata_orphan

gzip ${names[${SLURM_ARRAY_TASK_ID}]}_R1_kneaddata_paired_*.fastq
gzip ${names[${SLURM_ARRAY_TASK_ID}]}_R1_kneaddata_unmatched_*.fastq

echo "Completed ${names[${SLURM_ARRAY_TASK_ID}]} Kneaddata."
