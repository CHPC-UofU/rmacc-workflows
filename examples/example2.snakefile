# Generate a list of the sample names embedded in the file names.
import os
samples=[f.split('.')[0] for f in os.listdir('.') if f.endswith('.fastq.gz')]

rule all_sizes_and_checksums:
	input: expand("{sample}.{format}", sample=samples, format=["linecount","md5"])
	output: touch("sizes_and_checksums.done")  # Creates empty output file 
	message: "Confirming all fastq files have checksums and line counts."

rule one_size_and_checksum:
	input: "{sample}.fastq.gz"
	output: linecount="{sample}.linecount", checksum="{sample}.md5"
	message: "Calculating line count and checksum on {input}."
	shell:	"""
		gunzip -c {input} | wc -l > {output.linecount}
		md5sum {input} > {output.checksum}
		"""
