#!/usr/bin/env nextflow

/*
vim: syntax=groovy
*/

params.executable = 'simple_program'
params.cflags = '-c -g'
params.lnflags = '-g -o'

// Here's a channel for the .c files. It emits one .c file's 
// name at a time, and provides the inputs to the compile process.
c_files_channel = Channel.fromPath( '*.c' )

// This process compiles each .c file into a .o file.
process compile {
	input: 
		file c_file from c_files_channel
	output: 
		file '*.o' into o_files_channel
	script:
		"""
		module load gcc/4.9.2
		gcc ${params.cflags} ${c_file}
		"""
}

// This process links all the .o files into the executable program.
process link {
	input:
		// This .collect() method collects all the .o files together.
		file '*.o' from o_files_channel.collect()
	output:
		file params.executable into result
	script:
		"""
		module load gcc/4.9.2
		gcc ${params.lnflags} ${params.executable} *.o
		"""
}

result.subscribe { println "Compiled $it" }
