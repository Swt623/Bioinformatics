## 0. Set up environment

Get image file for singularity:

	module load singularity
	singularity build qiime2-2019.10.sif docker://qiime2/core:2019.10

Pull from docker:

	module load singularity
	singularity pull docker://qiime2/core:latest

Path/file: 

    /projects/p31421/Images/qiime2-2019.10.sif

Or, install through bioconda:

    conda env create -n qiime2-2021.4 --file qiime2-2021.4-py38-linux-conda.yml
    source activate qiime2-2021.4
    
[bioconda qiime page](https://bioconda.github.io/recipes/qiime/README.html)

## 1. [Prepare data](https://docs.qiime2.org/2021.4/tutorials/importing/)

* Import raw sequencing data as QIIME2 artifact:

For demultiplexed, paired end sequencing reads:

      qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \
      --input-path casava-18-paired-end-demultiplexed \
      --input-format CasavaOneEightSingleLanePerSampleDirFmt \
      --output-path demux-paired-end.qza

Viewing a summary of joined data with read quality:

    qiime demux summarize --i-data demux-joined.qza --o-visualization demux-joined.qzv

## 2. Denoising

Both Deblur and DADA2 contain internal *chimera checking* methods and *abundance filtering*, so additional filtering should not be necessary following these methods.

* Using data2:

      qiime dada2 denoise-paired \
      --i-demultiplexed-seqs demux.qza \
      --p-trim-left-f 13 \
      --p-trim-left-r 13 \
      --p-trunc-len-f 150 \
      --p-trunc-len-r 150 \
      --o-table table.qza \
      --o-representative-sequences rep-seqs.qza \
      --o-denoising-stats denoising-stats.qza

* Using Deblur:

**Quality control:

    qiime quality-filter q-score \
    --i-demux demux-joined.qza \
    --o-filtered-sequences demux-joined-filtered.qza \
    --o-filter-stats demux-joined-filter-stats.qza
    --p-min-quality 30
    
**Denoise using deblur:

    qiime deblur denoise-16S \
    --i-demultiplexed-seqs demux-joined-filtered.qza \
    --p-trim-length 250 \
    --p-sample-stats \
    --o-representative-sequences rep-seqs.qza \
    --o-table table.qza \
    --o-stats deblur-stats.qza

### Clustering

Quote: "

We cluster sequences to collapse similar sequences (e.g., those that are ≥ 97% similar to each other) into single replicate sequences. This process, also known as OTU picking, was once a common procedure, used to simultaneously dereplicate but also perform a sort of quick-and-dirty denoising procedure (to capture stochastic sequencing and PCR errors, which should be rare and similar to more abundant centroid sequences). Use denoising methods instead if you can. Times have changed. Welcome to the future. 😎
    
"

Three options: *de novo*, closed-reference, and open-reference clustering.

* *Denovo*:
  
      qiime vsearch cluster-features-de-novo \
      --i-table table.qza \
      --i-sequences rep-seqs.qza \
      --p-perc-identity 0.99 \
      --o-clustered-table table-dn-99.qza \
      --o-clustered-sequences rep-seqs-dn-99.qza

* Closed-reference: Required when you are comparing non-overlapping amplicons, such as the V2 and the V4 regions of the 16S rRNA. 

      qiime vsearch cluster-features-closed-reference \
      --i-table table.qza \
      --i-sequences rep-seqs.qza \
      --i-reference-sequences 85_otus.qza \
      --p-perc-identity 0.85 \
      --o-clustered-table table-cr-85.qza \
      --o-clustered-sequences rep-seqs-cr-85.qza \
      --o-unmatched-sequences unmatched-cr-85.qza

## 3. Taxonomy classification and taxonomic analyses

### 3.1 Classifying using pre-trained classifier

#### Get database

[QIIME 2 data resources](https://docs.qiime2.org/2020.11/data-resources/)

* Naive Bayes classifier trained on Silva 138 99% OTUs full-length sequences: silva-138-99-nb-retrain-classifier.qza
* Naive Bayes classifier trained on Silva 138 99% OTUs from 515F/806R region of sequences: silva-138-99-515-806-nb-classifier.qza
* Naive Bayes classifier trained on Greengenes 13_8 99% OTUs full-length sequences: gg-13-8-99-nb-classifier.qza
* Naive Bayes classifier trained on Greengenes 13_8 99% OTUs from 515F/806R region of sequences: gg-13-8-99-515-806-nb-classifier.qza

Generating taxonomy.qza:

      qiime feature-classifier classify-sklearn \
      --i-classifier silva-138-99-nb-retrain-classifier.qza \
      --i-reads rep-seqs.qza \
      --o-classification taxonomy.qza
  
Generating visualization artifact taxonomy.qzv from taxonomy.qza:

	qiime metadata tabulate \
	--m-input-file taxonomy.qza \
	--o-visualization taxonomy.qzv

### 3.2 Collapse taxonomy feature

[qiime taxa collapse](https://docs.qiime2.org/2021.4/plugins/available/taxa/collapse/)

	qiime taxa collapse \
	--i-table table.qza \
	--i-taxonomy taxonomy.qza \
	--p-level 6 # at genus level \
	--o-collapsed-table collapsed-table.qza
	
### 3.3 Differential abundance testing with ANCOM

*Assumption: <25% features are changing between groups. Should not use ANCOM if expect large change. 

* Create a FeatureTable[Composition] QIIME 2 artifact using a FeatureTable[Frequency]: 

      qiime composition add-pseudocount \
      --i-table table.qza \
      --o-composition-table comp-table.qza

*  Run ANCOM on the {subject} column to determine what features differ in abundance across the gut samples of the two subjects:

       qiime composition ancom \
       --i-table comp-table.qza \
       --m-metadata-file sample-metadata.tsv \
       --m-metadata-column subject \
       --o-visualization ancom-subject.qzv
    
    Can use collapsed FeatureTable for a differential abundance test at a specific taxonomic level. 

*How to interpret ancom vocano plot???

## 4. Alpha and beta diversity

### 4.1 Phylogenetic diversity analyses (Tree generation)

    qiime phylogeny align-to-tree-mafft-fasttree \
    --i-sequences rep-seqs.qza \
    --o-alignment aligned-rep-seqs.qza \
    --o-masked-alignment masked-aligned-rep-seqs.qza \
    --o-tree unrooted-tree.qza \
    --o-rooted-tree rooted-tree.qza

### 4.2 Alpha diversity



### 4.3 Beta diversity



## QIIME2 datafiles

* QIIME2 artifact: .qza
* QIIME2 visualization: .qzv

Viewing QIIME2 datafiles: https://view.qiime2.org/ 

Reference database for wastewater: https://midasfieldguide.org/guide

### [Qiime 2 plugins](https://docs.qiime2.org/2021.4/plugins/)
