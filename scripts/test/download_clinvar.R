# Check if the file already exists
if (file.exists("variant_summary.txt.gz")) {
  # File exists, so delete it
  cat("...previous version found... deleting file now....\n")
  file.remove("variant_summary.txt.gz")
}

# Download the latest ClinVar summary from FTP server
cat("...downloading latest ClinVar summary from: https://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/variant_summary.txt.gz...\n")
system("curl -o variant_summary.txt.gz https://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/variant_summary.txt.gz")
cat("...done...\n")
