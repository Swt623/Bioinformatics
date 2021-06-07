# Humann2

[HUMAnN 2.0 Tutorial](https://github.com/biobakery/biobakery/wiki/humann2)

## Imput: 
* a quality-controlled metagenome or metatranscriptome: fastq(.gz), fasta(.gz).
* alignment results: sam, bam, blast-like tsv
* gene table: tsv, biom

Blastm8 format is created by the following software: rapsearch2, usearch, and blast.

## Requirment: 
* Memory >= 16 G
* Disk space >= 10 G
* Operating system: Linux or Mac

## Download the database:
Download the ChocoPhlAn database providing $INSTALL_LOCATION as the location to install the database (approximate size = 5.6 GB).
`$ humann2_databases --download chocophlan full $INSTALL_LOCATION`

NOTE: The humann2 config file will be updated to point to this location for the default chocophlan database. If you move this database, please use the "humann2_config" command to update the default location of this database. Alternatively you can always provide the location of the chocophlan database you would like to use with the "--nucleotide-database " option to humann2.
* For other database information, refer to [biobakery/humann](https://github.com/biobakery/humann/blob/2.9/readme.md)

## Run humann2:
`$ humann2 --input $sample --output $output_dir`
or `$ humann2 -i $sample -o $output_dir`
NOTE: `$SAMPLENAME` can be set by the user with the option `--output-basename <$NEWNAME>`.

`--threads <1>         number of threads/processes`

See compelte option list [here](https://github.com/biobakery/humann/blob/2.9/readme.md#complete-option-list).

### [Standard workflow](https://github.com/biobakery/humann/blob/2.9/readme.md#standard-workflow)
1. Run Humann2 on filtered fastq files. 
2. Normalize the abundance output files.

    Select the scheme: 
* copies per million
* relative abundance

`$ humann2_renorm_table --input $SAMPLE_genefamilies.tsv --output $SAMPLE_genefamilies_relab.tsv --units relab`

Note: 
* gene family abundance is reported in RPK (reads per kilobase).
* gene families can be regrouped to different functional categories prior to normalization.

3. Join the output files

`$ humann2_join_tables --input $OUTPUT_DIR --output humann2_genefamilies.tsv --file_name genefamilies_relab`

`$ humann2_join_tables --input $OUTPUT_DIR --output humann2_pathcoverage.tsv --file_name pathcoverage`

`$ humann2_join_tables --input $OUTPUT_DIR --output humann2_pathabundance.tsv --file_name pathabundance_relab`

### [Output files](https://github.com/biobakery/humann/tree/2.9#output-files)

* gene families file

HUMAnN 2.0 uses the MetaPhlAn2 software along with the ChocoPhlAn database and translated search database for this computation.

Gene family abundance is reported in RPK (reads per kilobase) units to normalize for gene length.

RPK values can be further sum-normalized to adjust for differences in sequencing depth across samples.

* pathway abundance file

community- and species-level gene abundances.

Pathways with zero abundance are not included in the file.

Unlike gene abundance, a pathway's community-level abundance is not necessarily the sum of its stratified abundance values. 

The user has the option to provide a custom pathways database to HUMAnN 2.0.

* pathway coverage file

more confidently detected (1) or less confidently detected (0).

computed for the community as a whole, and for each detected species and the unclassified stratum.


## Utility scripts

### humann2_barplot

`$ humann2_barplot --input $table.tsv --feature $feature --outfile $dir-to-save-figures`

run `$ humann2_barplot -h` to see additional command line options.

### humann2_join_tables

`$ humann2_join_tables --input $INPUT_DIR --output $new_single_table --file_name $STR`

`--file_name $STR` will only join gene tables with $STR in file name.

run `$ humann2_join_tables -h` to see additional command line options.

### humann2_reduce_table

collapsing joined MetaPhlAn2 taxonomic profiles to a single joint profile

### [humann2_regroup_table](https://github.com/biobakery/humann/tree/2.9#humann2_regroup_table)

`$ humann2_regroup_table --input $TABLE --groups $GROUPS --output $regrouped_TABLE2`

run `$ humann2_regroup_table -h` to see additional command line options.

### [humann2_renorm_table](https://github.com/biobakery/humann/tree/2.9#humann2_renorm_table)

`$ humann2_renorm_table --input $TABLE --units $CHOICE --output $normalized_TABLE`

`$ CHOICE` = 'relab' relative abundance or 'cpm' copies per million.

run `$ humann2_renorm_table -h` to see additional command line options.

## [Joint taxonomic profile](https://github.com/biobakery/humann/tree/2.9#joint-taxonomic-profile)

1. Create taxonomic profiles for each of the samples in your set with MetaPhlAn2.
2. Join all of the taxonomic profiles:

`$ humann2_join_tables --input $DIR --output joined_taxonomic_profile.tsv`

3. Reduce this file into a taxonomic profile that represents the maximum abundances from all of the samples in your set.

`$ humann2_reduce_table --input joined_taxonomic_profile.tsv --output max_taxonomic_profile.tsv --function max --sort-by level`

4. Run HUMAnN 2.0 on all of the samples in your set, providing the max taxonomic profile.

`$ humann2 --input $SAMPLE.fastq --output $OUTPUT_DIR --taxonomic-profile max_taxonomic_profile.tsv`

4*. Alternative step 4 (save time):

4(1). Run HUMAnN 2.0 on one of your samples:

`$ humann2 --input $SAMPLE_1.fastq --output $OUTPUT_DIR --taxonomic-profile max_taxonomic_profile.tsv
`

4(2). Run HUMAnN 2.0 on the rest of your samples providing the custom indexed ChocoPhlAn database ($OUTPUT_DIR/$SAMPLE_1_humann2_temp/).

`$ humann2 --input $SAMPLE.fastq --output $OUTPUT_DIR --nucleotide-database $OUTPUT_DIR/$SAMPLE_1_humann2_temp/ --bypass-nucleotide-index`

## Other customizations: 

[Custom taxonomic profile](https://github.com/biobakery/humann/tree/2.9#custom-taxonomic-profile)

[Custom pathways database](https://github.com/biobakery/humann/tree/2.9#custom-pathways-database)

[Genus level gene families and pathways](https://github.com/biobakery/humann/tree/2.9#genus-level-gene-families-and-pathways)
