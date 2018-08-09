# Generate a list of the sample names embedded in the file names.
import os
samples=[f.split('.')[0] for f in os.listdir('.') if f.endswith('.fastq.gz')]

rule run_multiqc:
	input: "fastqc_all_samples.done"
	output: "multiqc_report.html", "multiqc_data"
	shell:	"""
		multiqc .
		"""

rule fastqc_all_samples:
	input: expand("{sample}_fastqc.{format}", sample=samples, format=["zip","html"])
	output: touch("fastqc_all_samples.done")

rule fastqc_one_sample:
	input: "{sample}.fastq.gz"
	output: "{sample}_fastqc.zip", "{sample}_fastqc.html"
	shell:	"""
		fastqc --noextract {input}
		"""
