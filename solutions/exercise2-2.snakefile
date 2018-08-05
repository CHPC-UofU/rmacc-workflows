# Generate a list of the sample names embedded in the file names.
import os
samples=[f.split('.')[0] for f in os.listdir('.') if f.endswith('.fastq.gz')]

rule run_multiqc:
	input: expand("{sample}_fastqc.{format}", sample=samples, format=["zip","html"])
	output: "multiqc_report.html", "multiqc_data"
	shell:	"""
		module load multiqc
		multiqc .
		"""

rule fastqc_one_sample:
	input: "{sample}.fastq.gz"
	output: "{sample}_fastqc.zip", "{sample}_fastqc.html"
	shell:	"""
		module load fastqc
		fastqc --noextract {input}
		"""
