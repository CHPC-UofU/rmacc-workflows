#!/usr/bin/env nextflow

/*
vim: syntax=groovy
*/

// Define some parameters:
params.executable = 'simple_program'
params.cflags = '-c -g'
params.lnflags = '-g -o'

// This process compiles each .c file into a .o file. 
// This is the same as compile3.nf, except instead of assigning the channel 
// to a variable, I just call Channel.fromPath in the input section here:
process compile {
	module 'gcc/4.9.2'
	input: 
		file c_file from Channel.fromPath( '*.c' )
	output: 
		file '*.o' into o_files_channel
	script:
		"""
		gcc ${params.cflags} ${c_file}
		"""
}

// This process links all the .o files into the executable program.
process link {
	// put the finished file(s) in the current directory:
	publishDir ".", mode: "copy", overwrite: true
	module 'gcc/4.9.2'
	input:
		// This collect() method collects all the .o files together:
		file '*.o' from o_files_channel.collect()
	output:
		file params.executable into result
	script:
		"""
		gcc ${params.lnflags} ${params.executable} *.o
		"""
}

result.subscribe { println "Compiled $it" }
