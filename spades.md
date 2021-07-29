SPAdes 3.15.3 

metaSPAdes – a pipeline for metagenomic data sets (see metaSPAdes options).

Recommended options: 

* BayesHammer/IonHammer: read error correction, to obtain high-quality assemblies

* MismatchCorrector: improves mismatch and short indel rates in resulting contigs and scaffolds


Installation:

    wget http://cab.spbu.ru/files/release3.15.3/SPAdes-3.15.3-Linux.tar.gz
    tar -xzf SPAdes-3.15.3-Linux.tar.gz
    cd SPAdes-3.15.3-Linux/bin/
    # Get path
    pwd
    # Add path to PATH
    export PATH=$PATH:{path to spades executables}
    # verify intallation
    spades.py --test
    
Input file:

paired-end reads, mate-pairs and single (unpaired) reads

FASTQ, FASTA

For read error correction: FASTQ or BAM

accepts gzip-compressed files

If adapter and/or quality trimming software has been used prior to assembly, files with the orphan reads can be provided as "single read files" for the corresponding read-pair library.

SPAdes options: 

    spades.py [options] -o <output_dir>

--meta   (same as metaspades.py) 

Currently metaSPAdes supports only a single short-read library which has to be paired-end 

--only-error-correction     Performs read error correction only

--only-assembler     Runs assembly module only.

--careful    Tries to reduce the number of mismatches and short indels. Also runs MismatchCorrector; recommended only for assembly of small genomes;not supported by metaSPAdes and rnaSPAdes

--continue     Continues SPAdes run from the specified output folder starting from the last available check-point. only allowed option is -o <output_dir> 

    spades.py --countinue -o <output_dir> 
    
--12 <file_name>     File with interlaced forward and reverse paired-end reads.

-1 <file_name>     File with forward reads.

-2 <file_name>     File with reverse reads.

--merged <file_name>     File with merged paired reads.  

-s <file_name>     File with unpaired reads.

-t <int> (or --threads <int>)     Number of threads. The default value is 16.

-m <int> (or --memory <int>)     Set memory limit in Gb. The default value is 250 Gb.
  
--cov-cutoff <float>     Read coverage cutoff value. Must be a positive float value, or "auto", or "off". Default value is "off". 
  
--custom-hmms <file or directory>     File or directory with amino acid HMMs for HMM-guided mode.
  
## For long Illumina paired reads (2x150 and 2x250)

We suggest using 350-500 bp fragments with 2x150 reads and 550-700 bp fragments with 2x250 reads.

Multi cells 2*150:

    spades.py -k 21,33,55,77 --careful <your reads> -o spades_output
 
Multi cells 2*250
  
    spades.py -k 21,33,55,77,99,127 --careful <your reads> -o spades_output
  
  
