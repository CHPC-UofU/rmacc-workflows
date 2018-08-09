#!/usr/bin/env nextflow 
/*
vim: syntax=groovy
*/

fastq_files = Channel.fromPath('*.fastq.gz')

process FastQC {
	input: 
		file fastq_file from fastq_files
	output: 
		set file('*.html'), file('*.zip') into fastqc_result
	shell:	"""
		fastqc --noextract $fastq_file
		"""
}

fastqc_result.subscribe { println "produced this: $it" }
