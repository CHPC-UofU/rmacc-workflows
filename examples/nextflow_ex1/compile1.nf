#!/usr/bin/env nextflow

/*
vim: syntax=groovy
*/

// Here's a channel for the .c files. It emits one .c file's 
// name at a time, and provides the inputs to the compile process.
c_files_channel = Channel.fromPath( '*.c' )

process compile {
	module 'gcc/4.8.5'
	input: 
		file c_file from c_files_channel
	output: 
		file '*.o' into result

	script:
	"""
	gcc -c -g ${c_file}
	"""
}

result.subscribe { println "Compiled $it" }
