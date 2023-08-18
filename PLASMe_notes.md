#### PLASMe is a tool to identify plasmid contigs from short-read assemblies using the Transformer. 
Please refer to [PLASMe](https://github.com/HubertTang/PLASMe) GitHub page for details
and [![DOI](https://zenodo.org/badge/578918028.svg)](https://zenodo.org/badge/latestdoi/578918028) for publication.

#### This page contains how to use PLASMe on Quest and example code. 

(1) Download PLASMe from Github

    git clone https://github.com/HubertTang/PLASMe.git

This was done on 7/25/2023. You can find the download on Quest in `/projects/b1180/software/PLASMe/`.

(2) Install all the dependencies

    # move to the directory contianing the .yaml file
    cd /projects/b1180/software/PLASMe/
    # create a conda environment using the .yaml file provided
    mamba env create -f plasme.yaml
    # activate the envrionment
    conda activate plasme

(3) Download the reference database

    # move to the directory containing the .py script for downloading the database
    cd /projects/b1180/software/PLASMe/
    # download the database in the same directory where PLASMe.py exists (required)
    python PLASMe_db.py
    # to increase the speed, you can also submit a job and use multiple threads for downloading
    python PLASMe_db.py --threads ${SLURM_CPUS_PER_TASK}

This was done on 7/25/2023. Database exists on Quest in `/projects/b1180/software/PLASMe/DB`.

#### Example script for submitting a job to run PLASMe

    #!/bin/bash
    
    #SBATCH -A <allocation>
    #SBATCH -p <partition>
    #SBATCH -N 1
    #SBATCH --cpus-per-task=24
    #SBATCH -t 04:00:00
    #SBATCH --mem=12G
    #SBATCH --job-name=PLASMe
    #SBATCH --mail-user=<email_address>
    #SBATCH --mail-type=ALL
    #SBATCH --output=/directory/to/log/files/PLASMe_%A_out.txt
    #SBATCH --error=/directory/to/log/files/PLASMe_%A_err.txt
    
    module purge all
    module load python/anaconda
    source activate plasme

    # Need to call PLASMe.py from its directory, where the DB is stored. 
    cd /projects/b1180/software/PLASMe/

    # Make a directory for output files and temporary files
    # If you are running multiple samples at the same time, make sure each sample has its own temp_dir. 
    # Otherwise temp files will be overwritten by processes of other samples and cause errors.  
    mkdir -p /directory/to/output/
    mkdir -p /directory/to/temp_files/per/sample/

    # Run PLASMe
    python PLASMe.py \
        /directory/to/assembly/sample.fasta \
        /directory/to/output/per/sample/filename_for_plasmid_contigs(plasme_output).fasta \
        --mode balance \
        --temp /directory/to/temp_files/per/sample/ \
        --thread ${SLURM_CPUS_PER_TASK}
