#!/usr/bin/env nextflow 
/*
vim: syntax=groovy
*/

fastq_files = Channel.fromPath('*.fastq.gz')

process FastQC {
	publishDir 'QcFiles', mode: 'move', overwrite: true
	input: 
		file fastq_file from fastq_files
	output: 
		set file('*.html'), file('*.zip') into fastqc_result
	shell:	"""
		fastqc --noextract $fastq_file
		"""
}

/* 
Here's a process to collect the FastQC output files, but then send
the publish directory name as input to multiqc. 
*/

publish_dir_channel = Channel.fromPath('QcFiles')

process MultiQC_setup {
	input:
		file fastqc_files from fastqc_result.collect()
		file publish_dir_name from publish_dir_channel
	output:
		file publish_dir_name into setup_result
	script:	"""
		echo "In MultiQC_setup"
		"""
		
}

process MultiQC {
	publishDir 'QcFiles', mode: 'move', overwrite: true
	input:
		file qc_file_directory from setup_result
	output:
		set file('multiqc_data'), file('multiqc_report.html') into multiqc_result
	shell:	"""
		multiqc $qc_file_directory
		"""
}

multiqc_result.subscribe { println "produced this: $it" }
