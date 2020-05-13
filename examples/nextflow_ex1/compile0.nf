#!/usr/bin/env nextflow

/*
vim: syntax=groovy
*/

// Here's a channel for the .c files. It emits one .c file's 
// name at a time.
c_files_channel = Channel.fromPath( '*.c' )

c_files_channel.subscribe { println "Dot c file $it" }
