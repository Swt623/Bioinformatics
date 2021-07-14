# [The Resistance Gene Identifier (RGI)](https://github.com/arpcard/rgi)

Reference data: CARD

Install RGI from Conda or Run RGI from Docker:
works for
* genomes, 
* genome assemblies, 
* proteomes, and 
* metagenomic sequencing

## How RGI works:

1， predict complete open reading frames (ORFs) using Prodigal (ignoring those less than 30 bp)

2， analyzes the predicted protein sequences (do this directly if protein sequences are submitted)

* if Prodigal fails to predict an AMR ORF, this will produce a false negative result

Prodigal's algorithms for low quality/coverage assemblies (i.e. contigs <20,000 bp)：

* Short contigs, 
* small plasmids, 
* low quality assemblies, or 
* merged metagenomic reads

Three paradigms: 
* Perfect
* Strict
* Loose (discovery)

Combined with phenotypic screening, the Loose algorithm allows researchers to hone in on new AMR genes.

3, results are organized via the Antibiotic Resistance Ontology classification:
* AMR Gene Family
* Drug Class
* Resistance Mechanism

4, JSON files created at the command line can be uploaded at the CARD website for visualization. 


# [RGI usage documentation](https://github.com/arpcard/rgi#id38)

## CARD reference data

### Get CARD database

    wget https://card.mcmaster.ca/latest/data
    tar -xvf data ./card.json

### Load CARD database

Local or working directory: 

    rgi load --card_json /path/to/card.json --local
    
System wide: 

    rgi load --card_json /path/to/card.json
    
## CARD's Resistomes & Variants data:

Additional CARD data pre-processing for metagenomics

Obtain WildCARD data

Load WildCARD data


## [Beta-testing algorithm for metagenomic short reads, genomic short reads.](https://github.com/arpcard/rgi#using-rgi-bwt-metagenomic-short-reads-genomic-short-reads) 

    rgi bwt -1 $read1 [-2 $read2] [-a {bowtie2, bwa}] [-n treads] -o $output_file_prefix [--clean] [--include_wildcard]

example: 

    rgi bwt -1 kneaddata_out/mate1.fasta -2 kneaddata_out/mate2.fasta -a bowtie2 -n 24 -o CARD_out/sample --clean --include_wildcard
    

### [RGI bwt output](https://github.com/arpcard/rgi#rgi-bwt-tab-delimited-output-details)

* read mapping results at allel and gene levels
* statistics files


    
