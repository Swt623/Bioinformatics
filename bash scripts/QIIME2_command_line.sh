# 0. importing sequence
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path BES_sequence/ \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt --output-path BES.qza
  
# 1.1 quality filtering
qiime quality-filter q-score --i-demux BES.qza --o-filtered-sequences BES-filtered.qza \
  --o-filter-stats BES-filter-stats.qza --p-min-quality 30

# 1.2 denoising
qiime deblur denoise-16S --i-demultiplexed-seqs BES-filtered.qza --p-trim-length 250 --p-sample-stats \
  --o-representative-sequences BES-rep-seqs.qza --o-table BES-rep-seqs-table.qza  --o-stats BES-deblur-stats.qza

# 2. Taxonomy classification
# 2.0 Training classifier using silva-138-99 database (scikit-learn version conflict on quest, need to retrain classifier)
qiime feature-classifier fit-classifier-naive-bayes --i-reference-reads silva-138-99-seqs.qza --i-reference-taxonomy silva-138-99-tax.qza 
  --o-classifier silva-138-99-nb-retrain-classifier.qza

# 2.1 Classifying using pre-trained classifier
# Naive Bayes classifier trained on Silva 138 99% OTUs full-length sequences: silva-138-99-nb-retrain-classifier.qza
# Naive Bayes classifier trained on Silva 138 99% OTUs from 515F/806R region of sequences: silva-138-99-515-806-nb-classifier.qza
# Naive Bayes classifier trained on Greengenes 13_8 99% OTUs full-length sequences: gg-13-8-99-nb-classifier.qza
# Naive Bayes classifier trained on Greengenes 13_8 99% OTUs from 515F/806R region of sequences: gg-13-8-99-515-806-nb-classifier.qza
qiime feature-classifier classify-sklearn \
  --i-classifier silva-138-99-nb-retrain-classifier.qza \
  --i-reads BES-rep-seqs.qza \
  --o-classification BES-silva-taxonomy.qza
  
# Generating visualization artifact
qiime metadata tabulate \
  --m-input-file BES-silva-taxonomy.qza \
  --o-visualization BES-silva-taxonomy.qzv

# 2.2 Collapse feature table
# this merges all features that share the same taxonomic assignment into a single feature
# p-level 6 = collapse at genus level
qiime taxa collapse \
--i-table BES-rep-seqs-table.qza \
--i-taxonomy BES-silva-taxonomy.qza \
--p-level 6 \
--o-collapsed-table BES-silva-collapsed-genus-table.qza

# 2.3 diversity analysis


# 2.4 differential abundance

# 3.3 Plot taxonomic composition
# Use taxa barplot
qiime taxa barplot \
  --i-table BES-rep-seqs-table.qza \
  --i-taxonomy BES-gg-taxonomy.qza \
  --m-metadata-file BES-metadata.tsv \
  --o-visualization taxa-bar-plots.qzv

feature-table heatmap

