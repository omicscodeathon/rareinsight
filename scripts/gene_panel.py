import csv

# Function to extract variants from the VCF file based on gene panel
def extract_variants(vcf_file, gene_panel_file, output_file):
    # Read gene panel
    gene_panel = set()
    with open(gene_panel_file, 'r') as gene_panel_csv:
        reader = csv.reader(gene_panel_csv)
        for row in reader:
            gene_panel.add(row[0])  # Assuming the gene names are in the first column

    # Extract variants
    with open(vcf_file, 'r') as vcf, open(output_file, 'w') as output:
        for line in vcf:
            if line.startswith('#'):  # Skip header lines
                output.write(line)
                continue

            columns = line.split('\t')
            info_column = columns[7]  # Assuming the INFO column is the 8th column
            csq_info = [x for x in info_column.split(';') if x.startswith('CSQ=')]

            if csq_info:
                csq_values = csq_info[0].split('=')[1].split(',')
                for csq in csq_values:
                    gene_name = csq.split('|')[3]  # Assuming gene name is in the 4th position
                    if gene_name in gene_panel:
                        output.write(line)
                        break

# Usage
vcf_file = 'input.vcf'
gene_panel_file = 'panel.txt'
output_file = 'output.vcf' 

extract_variants(vcf_file, gene_panel_file, output_file)
