
import pandas as pd

# rename index names
def clean_index_names(df, sep, read_min=0): # read in a dataframe and a separator for the index name cleaning
    if read_min != 0: # If read in raw read table and want to apply filter
        df = df[df > read_min].dropna(axis = 0, thresh = 1).fillna(value=0)
        # normalize by metaxa2 reads numbers
        taxa_relab_df = df.copy()
        for sample in list(df.columns):
            taxa_relab_df[sample] = df[sample]/df[sample].sum()
        df=taxa_relab_df#.drop(columns=['sum'])
    
    # get the list of index names
    index_list = list(df.index)
    for name in index_list:
        name_list = name.split(sep)
        n = len(name_list)
    # get the last nonempty item of the name list 
        for i in range (1,n):
            if name_list[-i] != "":
                df.rename(index = {name: name_list[-i]}, inplace=True)
                break
    # collapse by index
    index_name=df.index.name
    df=df.groupby(index_name).sum()
    return df

def metaphlan2_taxa_table(taxa_df, level):
    # define the dictionary:
    level_dict={'species': 's__',
                'genus': 'g__',
                'family': 'f__',
                'order': 'o__',
                'class': 'c__',
                'phylum': 'p__',
                'kingdom': 'k__'}
    
    # get the list of taxa from taxa_df
    taxa_list = list(taxa_df.index)

    # get taxa list at desired level
    level_list = [x for x in taxa_list if level_dict[level] in x]

    # get a sub dataframe containing only species level
    level_df = taxa_df.loc[level_list]

    # get rid of "x__"
    for name in list(level_df.index):
        level_df.rename(index = {name: name[3:].replace("_"," ")}, inplace = True)
    level_df.index.name=None
    return level_df


# sort by aggregated abundance and get the top n features from a dataframe
# dataframe has sample name as column, features (taxonomy annotation) as index
# return a new dataframe containing top n features
def sort_top_n(df, n):
    df['sum']=df.sum(axis=1)
    top_n_df = df.sort_values(by='sum',ascending=False).head(n)
    top_n_df = top_n_df.drop(columns=['sum'])
    df = df.drop(columns=['sum'])
    others_df = pd.DataFrame(df.sum(axis=0)-top_n_df.sum(axis=0),columns=['Others']).transpose()
    top_n_df = pd.concat([top_n_df,others_df],axis=0)
    return top_n_df


# join feature table with metadata table
# feature table: column names = sample ID; row names = feature ID (taxa, gene, etc)
# metadata: column names = sample characteristics; row names = sample ID
# Need to edit
def attach_metadata(data_df, meta_df):
    data_df = data_df.set_axis(list(meta_df.columns), axis=1)
    data_df = meta_df.append(data_df)
    data_df.index.name = "Feature"
    return data_df