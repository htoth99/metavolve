process HOSTINDEX {
    publishDir "${params.outdir}/hostindex", mode: "copy"
    
    input:
    path host_fasta

    output:
    tuple val('host_index'), path('host_index*')

    script:
    """
    bowtie2-build $host_fasta host_index
    """
}