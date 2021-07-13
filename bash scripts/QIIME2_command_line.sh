# importing sequence
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path BES_sequence/ 
  --input-format CasavaOneEightSingleLanePerSampleDirFmt --output-path BES.qza
  
# quality filtering
qiime quality-filter q-score --i-demux BES.qza --o-filtered-sequences BES-filtered.qza 
  --o-filter-stats BES-filter-stats.qza --p-min-quality 30

# denoising
qiime deblur denoise-16S --i-demultiplexed-seqs BES-filtered.qza --p-trim-length 250 --p-sample-stats 
  --o-representative-sequences BES-rep-seqs.qza --o-table BES-rep-seqs-table.qza  --o-stats BES-deblur-stats.qza

# clustering using closed reference (silva 0.99 reference sequence)
qiime vsearch cluster-features-closed-reference 
  --i-table BES-rep-seqs-table.qza --i-sequences BES-rep-seqs.qza --i-reference-sequences silva-138-99-seqs.qza 
  --p-perc-identity 0.99 
  --o-clustered-table BES-table-cr-99.qza --o-clustered-sequences BES-rep-seqs-cr-99.qza --o-unmatched-sequences BES-unmatched-cr-99.qza
# The features produced by clustering methods are known as operational taxonomic units (OTUs).

# Classifying using pre-trained classifier
qiime feature-classifier classify-sklearn --i-classifier silva-138-99-nb-classifier.qza 
  --i-reads BES-rep-seqs-cr-99.qza --o-classification BES-taxonomy.qza
# Generating visualization artifact
qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv
