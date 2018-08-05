#!/usr/bin/env nextflow

/*
vim: syntax=groovy
*/

params.executable = 'simple_program'

// Here's a channel for the .c files. It "emits" one .c file's 
// name at a time, and provides the inputs to the compile process.
c_files_channel = Channel.fromPath( '*.c' )

process compile {
	input: 
		file c_file from c_files_channel
	output: 
		file '*.o' into o_files_channel
	script:
		"""
		module load gcc/4.9.2
		gcc -c ${c_file}
		"""
}

process link {
	input:
		file '*.o' from o_files_channel.collect()
	output:
		file params.executable into result
	
	script:
		"""
		module load gcc/4.9.2
		gcc -o ${params.executable} *.o
		"""
}

result.subscribe { println "Compiled $it" }
