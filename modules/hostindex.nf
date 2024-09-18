process HOSTINDEX {
    publishDir "${params.outdir}/hostindex", mode: "copy"
    
    input:
    path host_fasta

    output:
    path 'host_index_dir'

    script:
    """
    bowtie2-build $host_fasta host_index

    mkdir -p host_index_dir
    mv *bt2 host_index_dir/
    """
}