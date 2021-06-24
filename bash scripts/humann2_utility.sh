#!/bin/bash

#SBATCH -A p31421
#SBATCH --job-name=humann2-utility

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1

#SBATCH -t 01:00:00 # Runtime in HH:MM:SS
#SBATCH -p short

#SBATCH --mem=4G
#SBATCH --output=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/humann2_utility_%A.out
#SBATCH --error=/projects/b1042/HartmannLab/weitao/monkeygut/job_files/humann2_utility_%A.err

# purge all modules
module purge all

# load needed modules
module load singularity

# get name list for job array
cd /projects/b1042/HartmannLab/weitao/greywater/kneaddata_out/
sample=($(cat kneaddata_out_samples.txt))

cd /projects/b1042/HartmannLab/weitao/greywater/humann2_out/
echo "Normalizing 12 samples (relative abundance)."

# loop over name list for normalization
for i in {0..11}
do
# run Humann2 utility in Singularity
  singularity exec -B /projects/b1042/ -B /projects/b1057/ /projects/b1057/biobakery_diamondv0822.sif humann2_renorm_table --input ${sample[${i}]}_genefamilies.tsv --output relab/${sample[${i}]}_genefamilies-relab.tsv --units relab

  singularity exec -B /projects/b1042/ -B /projects/b1057/ /projects/b1057/biobakery_diamondv0822.sif humann2_renorm_table --input ${sample[${i}]}_pathabundance.tsv --output relab/${sample[${i}]}_pathabundance-relab.tsv --units relab

done

# join tables
singularity exec -B /projects/b1042/ -B /projects/b1057/ /projects/b1057/biobakery_diamondv0822.sif humann2_join_tables --input relab/ --output humann2_genefamilies-relab-joined.tsv --file_name genefamilies-relab

singularity exec -B /projects/b1042/ -B /projects/b1057/ /projects/b1057/biobakery_diamondv0822.sif humann2_join_tables --input relab/ --output humann2_pathabundance-relab-joined.tsv --file_name pathabundance-relab

singularity exec -B /projects/b1042/ -B /projects/b1057/ /projects/b1057/biobakery_diamondv0822.sif humann2_join_tables --input ./ --output humann2_pathcoverage-joined.tsv --file_name pathcoverage
