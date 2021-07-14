# 0. importing sequence
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path BES_sequence/ \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt --output-path BES.qza
  
# 1.1 quality filtering
qiime quality-filter q-score --i-demux BES.qza --o-filtered-sequences BES-filtered.qza \
  --o-filter-stats BES-filter-stats.qza --p-min-quality 30

# 1.2 denoising
qiime deblur denoise-16S --i-demultiplexed-seqs BES-filtered.qza --p-trim-length 250 --p-sample-stats \
  --o-representative-sequences BES-rep-seqs.qza --o-table BES-rep-seqs-table.qza  --o-stats BES-deblur-stats.qza

# 2.1 clustering using closed reference (silva 0.99 reference sequence)
qiime vsearch cluster-features-closed-reference \
  --i-table BES-rep-seqs-table.qza --i-sequences BES-rep-seqs.qza --i-reference-sequences silva-138-99-seqs.qza 
  --p-perc-identity 0.99 
  --o-clustered-table BES-table-cr-99.qza --o-clustered-sequences BES-rep-seqs-cr-99.qza --o-unmatched-sequences BES-unmatched-cr-99.qza
# The features produced by clustering methods are known as operational taxonomic units (OTUs).

# 2.2 following clustering, remove chimera (de novo)
# filter chimeric sequences
qiime vsearch uchime-denovo \
  --i-table BES-table-cr-99.qza \
  --i-sequences BES-rep-seqs-cr-99.qza \
  --output-dir uchime-dn-out

# exclude chimeras but retain "borderline chimeras"
# in this sample set, if exclude borderline chimeras there will be no data in output
# exclude from feature table
qiime feature-table filter-features \
  --i-table BES-rep-seqs-table.qza \
  --m-metadata-file uchime-dn-out/chimeras.qza \
  --p-exclude-ids \
  --o-filtered-table uchime-dn-out/BES-table-nonchimeric-w-borderline.qza

# exclude from sequences
qiime feature-table filter-seqs \
  --i-data BES-rep-seqs-cr-99.qza \
  --m-metadata-file uchime-dn-out/chimeras.qza \
  --p-exclude-ids \
  --o-filtered-data uchime-dn-out/BES-rep-seqs-nonchimeric-w-borderline.qza

# visualization of feature table with chimeric sequence removed.
qiime feature-table summarize \
  --i-table uchime-dn-out/BES-table-nonchimeric-w-borderline.qza \
  --o-visualization uchime-dn-out/BES-table-nonchimeric-w-borderline.qzv

# 3. Taxonomy classification
# 3.0 Training classifier using silva-138-99 database (scikit-learn version conflict on quest, need to retrain classifier)
qiime feature-classifier fit-classifier-naive-bayes --i-reference-reads silva-138-99-seqs.qza --i-reference-taxonomy silva-138-99-tax.qza 
  --o-classifier silva-138-99-nb-retrain-classifier.qza

# 3.1 Classifying using pre-trained classifier
qiime feature-classifier classify-sklearn \
  --i-classifier silva-138-99-nb-retrain-classifier.qza \
  --i-reads uchime-dn-out/BES-rep-seqs-nonchimeric-w-borderline.qza \
  --o-classification BES-taxonomy.qza
  
# Generating visualization artifact
qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv

# 3.2 Collapse feature table
# this merges all features that share the same taxonomic assignment into a single feature
taxa collapse

# diversity analysis
# differential abundance

# 3.3 Plot taxonomic composition
taxa barplot

feature-table heatmap

