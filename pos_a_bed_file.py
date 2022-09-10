import csv
import pybedtools
import sys

# This program accepts as input a chromosome and start and end and
# produces a bed file of all the adenosines that appear in the segment

def bed_a_pos(csv_read, csv_write):
    list_of_alu = []
    with open(csv_read, 'r') as file_read:
        alu_csv = csv.reader(file_read)
        with open(csv_write, 'w', newline="") as file:
            pos_a = csv.writer(file)
            for row in alu_csv:
                name_first = row[0] + ":" + row[1] + ":" + row[2] + ":" + row[5]
                name_second = row[6] + ":" + row[7] + ":" + row[8] + ":" + row[11]
                list_of_alu.append([row[0],row[1],row[2],row[5],name_first])
                list_of_alu.append([row[6],row[7],row[8],row[11],name_second])

            for alu in list_of_alu:
                chr = alu[0]
                start = int(alu[1])
                end = int(alu[2])
                strand = alu[3]
                fasta = pybedtools.bedtool.BedTool.seq((chr, start, end), 'hg38.fa')
                pos = start
                for nuc in fasta:
                    if strand == "+":
                        if nuc == 'a' or nuc == 'A':
                            pos_a.writerow([chr, str(int(pos+1)), strand, alu[4]])
                    else:
                        if nuc == 't' or nuc == 'T':
                            pos_a.writerow([chr,str(int(pos+1)),strand,alu[4]])
                    pos+=1



def main():

    with open( sys.argv[5], 'w', newline="") as file:
        pos_a = csv.writer(file)
        chr = sys.argv[1]
        start = int(sys.argv[2])
        end = int(sys.argv[3])
        strand = sys.argv[4]
        pos = start
        fasta = pybedtools.bedtool.BedTool.seq((chr, start, end), 'hg38.fa')
        for nuc in fasta:
            if strand == "+":
                if nuc == 'a' or nuc == 'A':
                    pos_a.writerow([chr, str(int(pos+1)), strand])
            else:
                if nuc == 't' or nuc == 'T':
                    pos_a.writerow([chr, str(int(pos+1)), strand])
            pos += 1


if __name__ == '__main__':
    main()
