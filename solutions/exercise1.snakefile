# ex1.snakefile - solution to exercise 1.
rule fastqc:
	input: "SRR5934916.fastq.gz"
	output: "SRR5934916_fastqc.zip", "SRR5934916_fastqc.html"
	# Here's an optional message, printed to standard output:
	message: "Running Fastqc on input file {input}."
	shell:	"fastqc --noextract {input}"
