# The Resistance Gene Identifier (RGI) [https://github.com/arpcard/rgi]

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

