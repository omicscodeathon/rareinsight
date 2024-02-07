import os
import csv

def collect_paired_reads(directory):
    # List all files in the directory
    files = os.listdir(directory)
    
    # Filter files for read1 and read2
    read1_files = sorted([file for file in files if file.endswith("_1.fastq.gz")])
    read2_files = sorted([file for file in files if file.endswith("_2.fastq.gz")])
    
    # Ensure that only paired reads are considered
    paired_reads = []
    for read1 in read1_files:
        read2 = read1.replace("_1.fastq.gz", "_2.fastq.gz")
        if read2 in read2_files:
            paired_reads.append((read1, read2))
    
    return paired_reads

def extract_basename(filename):
    return filename.split("_")[0]

def write_samplesheet(paired_reads):
    with open("samplesheet.csv", "w", newline="") as csvfile:
        fieldnames = ["sample", "lane", "fastq_1", "fastq_2", "sex", "phenotype", "paternal_id", "maternal_id", "case_id"]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        
        writer.writeheader()
        
        lane_counter = 1
        for read1, read2 in paired_reads:
            base_name = extract_basename(read1)
            writer.writerow({"sample": base_name, "lane": lane_counter, "fastq_1": read1, "fastq_2": read2, "sex": "", "phenotype": "", "paternal_id": "", "maternal_id": "", "case_id": ""})
            lane_counter += 1

def main():
    directory = input("Enter the directory containing the read files: ")
    paired_reads = collect_paired_reads(directory)
    
    if not paired_reads:
        print("No paired read files found in the directory.")
        return
    
    write_samplesheet(paired_reads)
    print("Samplesheet created successfully.")

if __name__ == "__main__":
    main()

