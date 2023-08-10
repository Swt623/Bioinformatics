import re
import pandas as pd

def prokka_tbl2csv(input_tbl_file):
#### Input variable is the .tbl output from Prokka.
#### This function will return a dataframe with ['feature', 'start', 'end', 'ftype', 'gene', 'locus_tag', 'product'] as columns,
#### where `feature` is the sequence ID (from the .fasta file fed to Prokka)
    # Regular expression patterns to grab ORF info from the .tbl file.
    feature_pattern = r'^>Feature\s+(\S+)$'
    entry_pattern = r'^(\d+)\s+(\d+)\s+(\S+)$'
    attribute_pattern = r'^\s+(\S+)\s+(.+)$'

    # Lists to store the extracted data
    data = []
    current_feature = None
    current_cds_data = None
    gene_found = False

    # Read the input .tbl file
    with open(input_tbl_file, 'r') as file:
        for line in file:
            # Check for a new feature entry
            feature_match = re.match(feature_pattern, line)
            if feature_match:
                current_feature = feature_match.group(1)
            else:
                # Check for attribute entries (start, end, ftype, gene, locus_tag, product)
                entry_match = re.match(entry_pattern, line)
                if entry_match:
                    start, end, ftype = entry_match.groups()
                    current_cds_data = [current_feature, start, end, ftype]
                    gene_found = False  # Reset the flag for each CDS entry
                else:
                    attribute_match = re.match(attribute_pattern, line)
                    if attribute_match:
                        attribute_name, attribute_value = attribute_match.groups()
                        if attribute_name == 'gene':
                            current_cds_data.append(attribute_value)
                            gene_found = True
                        elif attribute_name == 'locus_tag':
                            current_cds_data.append(attribute_value)
                        elif attribute_name == 'product':
                            current_cds_data.append(attribute_value)
                            if not gene_found:
                                current_cds_data.insert(4, '')  # Insert an empty string for "gene" column
                            data.append(current_cds_data)

    # Convert the list of data to a DataFrame
    columns = ['feature', 'start', 'end', 'ftype', 'gene', 'locus_tag', 'product']
    df = pd.DataFrame(data, columns=columns)
    print(f'Parsing {input_tbl_file} complete.')

    return df
