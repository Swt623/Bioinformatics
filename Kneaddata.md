# Install:
$pip install --user kneaddata
	
# Download the human reference database:
$kneaddata_database --download human_genome bowtie2 $DIR

# Remove contamination (example: remove human genes from the reads): 
$kneaddata --input <dir/file-name1> --input <dir/file-name2> --reference-db <dir/database-prefix> --output <output-folder-name> --threads <number of threads>
  >If only use folder name for output files, the folder will be created in the current directory.
