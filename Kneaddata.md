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
