import sys
import pandas as pd

# This program receives the output of running known for all samples and path to output csv and consolidates the data for each Position

def main():
    df = pd.read_csv(sys.argv[1])
    new_df = pd.DataFrame(columns=['Position','Strand', 'Coverage', 'A', 'C', 'G', 'T','Frequency'])
    unique_pos = pd.unique(df["Position"])
    for p in unique_pos:
        locations = df["Position"] == p
        Coverage = df[["Coverage-q25"]][locations]
        sum_Coverage = Coverage.sum().iloc[0]
        Strand = df[['Strand']][locations]
        Strand = Strand.iloc[0,:]
        A = df[["A"]][locations]
        A = A.sum().iloc[0]
        C = df[["C"]][locations]
        C = C.sum().iloc[0]
        G = df[["G"]][locations]
        G = G.sum().iloc[0]
        T = df[["T"]][locations]
        T = T.sum().iloc[0]
        Frequency = float(G) / (float(A) + float(G))
        new_df = new_df.append({'Position': p, 'Strand' : Strand, 'Coverage' :sum_Coverage, 'A' : A, 'C': C, 'G':G, 'T':T , 'Frequency' : Frequency}, ignore_index=True)

    new_df.to_csv(sys.argv[2])


if __name__ == '__main__':
    main()
