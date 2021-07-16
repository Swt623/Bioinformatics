"""
Grab the total metaxa2 output 16S reads numbers from each sample
"""

# file that stores summary file names
file_name = "metaxa2_summary_file_names.txt"
search_words = "Will process "
reads_file = "reads_summary.txt"

file_list = []
# get a list of file names
with open(file_name, "r") as f:
    for line in f.readlines():
        file_list.append(line.rstrip("\n"))

# construct a dictionary with sample name as key, total metaxa2 reads as value
reads_dict = {}
for file in file_list:
    with open(file, "r") as f:
        for line in f.readlines():
            if line.startswith(search_words):
                word = line.split(" ")
                reads = int(word[2])
    sample = file.split(".")[0]
    reads_dict[sample] = reads

with open(reads_file, "w") as f:
    for k, v in reads_dict.items():
        f.write('%s:%s\n' % (k, v))
