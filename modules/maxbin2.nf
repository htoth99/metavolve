process MAXBIN2 {
    input:
    tuple val(sample_id), path(reads)
    path contig_assembly

    output:
    path ('*.fasta')

    script:
    """
    run_MaxBin.pl \
    -contig $contig_assembly \
    -reads ${reads[0]} \
    -reads2 ${reads[1]} \
    -out $sample_id
    """
}

