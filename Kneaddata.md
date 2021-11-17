## Install:

	pip install --user kneaddata
	
or 

	conda create -n kneaddata -c bioconda kneaddata
	
to specify python version:

	conda create -n kneaddata-py27 python=2.7 kneaddata
	
## Download the human reference database:

	kneaddata_database --download human_genome bowtie2 $DIR

## Use bowtie2 to build customized database (contaminant database)

	module load bowtie2
	bowtie2-build $data.fasta $DIR/database_basename

## Remove contamination (example: remove human genes from the reads): 

	kneaddata --input <dir/file-name1> --input <dir/file-name2> --reference-db <dir/database-prefix> --output <output-folder-name> --threads <number of threads>
	
If only use folder name for output files, the folder will be created in the current directory.


# Below flags not available for <=v0.10.0

Kneaddata installed as conda environment: v0.7.4

Kneaddata as singularity image: v0.6.1

## It is highly reccommended to choose the correct sequencer source to ensure the removal of adapter contents by Kneaddata.

        --sequencer-source ["NexteraPE", "TruSeq2", "TruSeq3","none"]
	
Example:
	
	kneaddata --unpaired demo.fastq -db demo_db -o kneaddata_output --sequencer-source TruSeq3 --fastqc FastQC
	
## It is highly recommeded to use --run-trim-repetitive flag for Shotgun sequences (Metatranscriptomics-MTX, Metagenomics-MGX) to trim the overrepresented sequences if shown in FASTQC reports.

Example: 

        kneaddata --unpaired demo.fastq -db demo_db -o kneaddata_output --run-trim-repetitive --sequencer-source TruSeq3 --fastqc FastQC

