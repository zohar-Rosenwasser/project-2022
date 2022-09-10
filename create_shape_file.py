import sys
import pandas as pd



#This script produces a shape file that can be given to the software for drawing the structures as output.

# argumant:
# 1 - input csv
# 2 - output csv
# 3 - start
# 4 - end
# 5 - strand

def main():
    df = pd.read_csv(sys.argv[1])
    start = sys.argv[3]
    end = sys.argv[4]
    strand = sys.argv[5]
    position = 0
    new_df = pd.DataFrame(columns=['Position', 'Frequency'])
    for p in df.index:
        if strand == "-":
            position = int(int(end) - int(df['Position'][p]) + 1)
        else:
            position = int(df['Position'][p]) - int(start) + 1
        Frequency = df['Frequency'][p]
        if Frequency > 0.001:
            new_df = new_df.append({'Position': position, 'Frequency' : Frequency}, ignore_index=True)

    new_df.to_csv(sys.argv[2], header=None, index=False)







if __name__ == '__main__':
    main()