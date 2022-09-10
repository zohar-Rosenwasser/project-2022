import sys

import numpy as np
import pandas as pd
import os

'''This script unifies the editing data for all tissues'''

# sys.argv[1] = pos_a_csv
# sys.argv[2] = root directory
# sys.argv[3] = name of csv combine all tissue

def main():


    list_pos_a = []
    pos_a = pd.read_csv(sys.argv[1], header=None)
    pos_a.columns = ['chr', 'pos', 'strand']
    for index, row in pos_a.iterrows():
        pos = row['pos']
        list_pos_a.append(pos)

    all_tissue_editing = pd.DataFrame()
    all_tissue_editing['Position'] = list_pos_a


    root = sys.argv[2]
    for filename in os.listdir(root):
        dir1 =  root + "/" + filename
        if os.path.isdir(dir1):
            dir = root + "/" + filename
        else:
            print(filename)
            continue

        num_sample = -1
        print("hi")
        for file in os.listdir(dir):
            print(root + "/" + filename + "/" + file)
            if os.path.isdir(root + "/" + filename + "/" + file):
                num_sample +=1;
        print(num_sample)
        for file in os.listdir(dir):
            mean_coverage_list = []
            if file == "REDItoolKnown.out.combinedAll.csv":
                full_path_table = dir + "/" + "REDItoolKnown.out.combinedAll.csv"
                data = pd.read_csv(full_path_table)
                for pos_list in list_pos_a:
                    b = False;
                    for index, row in data.iterrows():
                        pos = row['Position']
                        coverage = row['Coverage']
                        print(coverage)
                        if pos == pos_list:
                            mean_coverage_list.append(coverage/num_sample)
                            print(mean_coverage_list)
                            b = True
                    if not b:
                        mean_coverage_list.append(0)
                        b = False;
                    mean_cov = sum(mean_coverage_list) / float(len(mean_coverage_list))
                    mean_coverage_list.append(mean_cov)

                all_tissue_editing[str(filename)] = mean_coverage_list

    all_tissue_editing.to_csv(sys.argv[3])

if __name__ == '__main__':
    main()

