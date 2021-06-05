#!/bin/bash

#SBATCH -A p31421
#SBATCH --job-name=Merge_rerun

#SBATCH --mail-user=weitao.shuai@northwestern.edu
#SBATCH --mail-type=ALL

#SBATCH -N 1

#SBATCH -t 04:00:00 # Runtime in D-HH:MM
#SBATCH -p short

#SBATCH --mem=24G

#SBATCH --output=/projects/p31421/MonkeyGut/job_files/%A.out
#SBATCH --error=/projects/p31421/MonkeyGut/job_files/%A.err

# get name list
cd /projects/b1042/HartmannLab/weitao/monkeygut
names=($(cat Failed_SampleNames.txt))

# loop over name list
for i in {0..16}
do
  FILE2=/projects/b1057/shotgun_howlers/batch2/${names[$i]}_R1_001.fastq.gz
  if test -f "$FILE2"
  then
# merge two fastq.gz files from different folder with same name
    cat /projects/b1057/shotgun_howlers/batch1/${names[$i]}_R1_001.fastq.gz /projects/b1057/shotgun_howlers/batch2/${names[$i]}_R1_001.fastq.gz > /projects/b1057/shotgun_howlers/rerun_merged/${names[$i]}_R1.fastq.gz
    cat /projects/b1057/shotgun_howlers/batch1/${names[$i]}_R2_001.fastq.gz /projects/b1057/shotgun_howlers/batch2/${names[$i]}_R2_001.fastq.gz > /projects/b1057/shotgun_howlers/rerun_merged/${names[$i]}_R2.fastq.gz
  else
    cat /projects/b1057/shotgun_howlers/batch1/${names[$i]}_R1_001.fastq.gz /projects/b1057/shotgun_howlers/batch3/${names[$i]}_R1_001.fastq.gz > /projects/b1057/shotgun_howlers/rerun_merged/${names[$i]}_R1.fastq.gz
    cat /projects/b1057/shotgun_howlers/batch1/${names[$i]}_R2_001.fastq.gz /projects/b1057/shotgun_howlers/batch3/${names[$i]}_R2_001.fastq.gz > /projects/b1057/shotgun_howlers/rerun_merged/${names[$i]}_R2.fastq.gz
  fi
done

echo "Completed merging ${names[$i]}."
