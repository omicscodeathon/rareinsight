def extract_info(vcf_file, output_file):
    with open(vcf_file, 'r') as vcf, open(output_file, 'w') as output:
        for line in vcf:
            if line.startswith('#'):
                output.write(line)
                continue

            columns = line.strip().split('\t')
            chrom = columns[0]
            pos = columns[1]
            identifier = columns[2]
            ref = columns[3]
            alt = columns[4]
            qual = columns[5]
            filter_info = columns[6]
            info_column = columns[7]

            # Set format and name columns to "NA"
            format_col = 'NA'
            name_col = 'NA'

            # Split INFO column by ';'
            info_fields = info_column.split(';')

            # Extract CSQ information
            csq_info = [x.split('=')[1] for x in info_fields if x.startswith('CSQ=')]
            csq_info = csq_info[0] if csq_info else '.'

            # Extract CLNDN information
            clndn_info = [x.split('=')[1] for x in info_fields if x.startswith('CLNDN=')]
            clndn_info = clndn_info[0] if clndn_info else '.'

            # Extract CLINSIG information
            clnsig_info = [x.split('=')[1] for x in info_fields if x.startswith('CLNSIG=')]
            clnsig_info = clnsig_info[0] if clnsig_info else '.'

            # Write extracted information to output file
            for csq_entry in csq_info.split(','):
                csq_fields = csq_entry.split('|')
                csq_dict = dict(zip([
                    'Allele', 'Consequence', 'IMPACT', 'SYMBOL', 'Gene', 'Feature_type',
                    'Feature', 'BIOTYPE', 'EXON', 'INTRON', 'HGVSc', 'HGVSp', 'cDNA_position',
                    'CDS_position', 'Protein_position', 'Amino_acids', 'Codons',
                    'Existing_variation', 'DISTANCE', 'STRAND', 'FLAGS', 'SYMBOL_SOURCE',
                    'HGNC_ID'
                ], csq_fields))

                # Write formatted CSQ fields along with other relevant columns
                output.write(f"{chrom}\t{pos}\t{identifier}\t{ref}\t{alt}\t{qual}\t{filter_info}\t")
                output.write(";".join([f"{heading}={csq_dict.get(heading, '.')}" for heading in csq_dict.keys()]))
                output.write(f";CLNDN={clndn_info};CLNSG={clnsig_info}\t{format_col}\t{name_col}\n")


# Usage
vcf_file = 'output_panel.vcf'
output_file = 'filtered_vcf.vcf'

extract_info(vcf_file, output_file)
