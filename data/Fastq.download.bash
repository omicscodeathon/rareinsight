#!//bin/bash

# check if file exists 
if [ !-f download.txt ]; then
	echo "Error:download.txt file not present"
	exit 1
fi

# create a directory to store downloaded files

	mkdir -p downloaded_samples

# change directory
 	
cd downloaded_samples
	
# Download samples using wget from ftp URLs
while read -r sample ; do
	echo "Downolading $sample"
wget --user=anonymous --password = '' "$sample"
done < ../download.txt
# Print message for succesfully complete the download of samples

echo "download complete"

#move bacbk to original directory
cd ..

# Redirect output to nohup.out 
exec > nohup.out 2>&1

