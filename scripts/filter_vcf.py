import csv

def extract_info(vcf_file, gene_panel_file, output_file):
    # Read gene panel
    gene_panel = set()
    with open(gene_panel_file, 'r') as gene_panel_csv:
        reader = csv.reader(gene_panel_csv)
        for row in reader:
            gene_panel.add(row[0])  # Assuming the gene names are in the first column

    # Extract variants and information
    with open(vcf_file, 'r') as vcf, open(output_file, 'w') as output:
        output.write("Gene\tAmino Acid change\tProtein Change\tClinical Diagnosis\tClinical Significance\n")

        for line in vcf:
            if line.startswith('#'): #Skips headers
                continue

            columns = line.split('\t')
            info_column = columns[7]  # Assuming the INFO column is the 8th column

            # Extract CSQ information
            csq_info = [x.split('=')[1] for x in info_column.split(';') if x.startswith('CSQ=')]
            csq_info = csq_info[0] if csq_info else '.'

            # Extract CLNDN information
            clndn_info = [x.split('=')[1] for x in info_column.split(';') if x.startswith('CLNDN=')]

            # Extract CLNSIG information
            clnsig_info = [x.split('=')[1] for x in info_column.split(';') if x.startswith('CLNSIG=')]
            clnsig_info = clnsig_info[0] if clnsig_info else '.'

            # Extract gene name
            gene_name = None
            csq_values = csq_info.split(',')
            for csq in csq_values:
                fields = csq.split('|')
                if len(fields) >= 4:
                    gene_name = fields[3]  # Assuming gene name is in the 4th position
                    if gene_name in gene_panel:
                        csq_column1 = fields[3]  # Assuming gene name is in the 4th position
                        csq_column2 = fields[10]  # Assuming the other required column is in the 11th position
                        csq_column3 = fields[11]  # Assuming the other required column is in the 12th position
                        output.write(f"{csq_column1}\t{csq_column2}\t{csq_column3}\t{clndn_info}\t{clnsig_info}\n")
                        break

# Usage
vcf_file = 'input.vcf'
gene_panel_file = 'gene_panel.txt'
output_file = 'output.txt'
