#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process test_resume1 {
	container 'ubuntu:20.04'
	echo true
	publishDir "${params.outdir}", mode:'copy'
	
	input:
		path('input.txt')
	
	output:
		path('*.*'), emit: out_ch1
	
	script:
	"""
		echo "executing A"
		echo "Executing process 1   " > A_file.txt
		
	"""
}

process test_resume2 {
	container 'ubuntu:20.04'
	echo true
	publishDir "${params.outdir}", mode:'copy'	
	
	output:
		path('*.*'), emit: out_ch2
	
	script:
	"""	
		echo "executing B"
		echo "Executing process 2 " > B_file.txt
	"""
}


process test_resume3 {
	container 'ubuntu:20.04'
	echo true
	publishDir "${params.outdir}", mode:'copy'	
			
	output:
		path('*.*'), emit: out_ch3
	
	script:
	"""	
		echo "executing C"
		echo "Executing process 3 " > C_file.txt
	"""
}

workflow {
	test_resume1(Channel.fromPath(params.input, checkIfExists: true))
	test_resume2()
	test_resume3()
	test_resume1.out.out_ch1.view()
	test_resume2.out.out_ch2.view()
	test_resume3.out.out_ch3.view()
	
}

workflow.onComplete {
    println "Pipeline completed at: $workflow.complete"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}

workflow.onError = {
    println "Oops .. something when wrong"
}

