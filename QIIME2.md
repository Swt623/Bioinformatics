## 0. Set up environment

Get image file for singularity:

	module load singularity
	singularity build qiime2-2019.10.sif docker://qiime2/core:2019.10
  
Path/file: 

    /projects/p31421/Images/qiime2-2019.10.sif

Or, install through bioconda:

    conda env create -n qiime2-2021.4 --file qiime2-2021.4-py38-linux-conda.yml
    source activate qiime2-2021.4

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
    
**Denoise:

    qiime deblur denoise-16S \
    --i-demultiplexed-seqs demux-joined-filtered.qza \
    --p-trim-length 250 \
    --p-sample-stats \
    --o-representative-sequences rep-seqs.qza \
    --o-table table.qza \
    --o-stats deblur-stats.qza

## 3. Clustering

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

* Get database

[QIIME 2 data resources](https://docs.qiime2.org/2020.11/data-resources/)

### QIIME2 datafiles

* QIIME2 artifact: .qza
* QIIME2 visualization: .qzv

Viewing QIIME2 datafiles: https://view.qiime2.org/ 

