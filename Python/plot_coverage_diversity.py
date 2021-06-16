# plot nonpareil output in with numbers

# import packages
import pandas as pd
import seaborn as sns
import os
import matplotlib.pyplot as plt

# Set the figure size - handy for larger output
plt.rcParams["figure.figsize"] = [10, 8]

path='/Users/shuaishuai/Google Drive/Research/NorthwesternUniversity/Greywater_Metagemonics/Greywater_Data/'
npOutFile='R-nonpareil-out.csv'

# change directory to path
os.chdir(path)
# read nonpareil output as dataframe
npo_df = pd.read_csv(npOutFile)

#fig1=sns.scatterplot(x="diversity", y="C", data=npo_df)
#fig1.set_xlabel('Diversity')
#fig1.set_ylabel('Coverage')
#plt.savefig('diversity_coverage.pdf',bbox_inches='tight')

# hue by Sample
#fig2=sns.scatterplot(x="diversity", y="C", data=npo_df, hue="Sample")
#fig2.set_xlabel('Diversity')
#fig2.set_ylabel('Coverage')
#fig2.savefig('diversity_coverage_bySample.pdf',bbox_inches='tight')

# hue by Treatment
fig3=sns.scatterplot(x="diversity", y="C", data=npo_df, hue="Treatment")
fig3.set_xlabel('Diversity')
fig3.set_ylabel('Coverage')
plt.savefig('diversity_coverage_byTreatment.pdf',bbox_inches='tight')

# bar plot diversity
fig_d = sns.catplot(
    data=npo_df, kind="bar",
    x="Sample", y="diversity", hue="Treatment",
)
fig_d.set_axis_labels("","Diversity")
plt.xticks(rotation=30, horizontalalignment="center")
plt.savefig('diversity_bar_byTreatment.pdf',bbox_inches='tight')

# bar plot Coverage
fig_c = sns.catplot(
    data=npo_df, kind="bar",
    x="Sample", y="C", hue="Treatment",
)
fig_c.set_axis_labels("","Coverage")
plt.xticks(rotation=30, horizontalalignment="center")
plt.savefig('coverage_bar_byTreatment.pdf',bbox_inches='tight')
