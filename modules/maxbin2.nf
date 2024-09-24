process MAXBIN2 {
    input:
    tuple val(sample_id), path(fasta_assembly), path(bam_file), path(bam_index), path(bed_file), path(trim_reads)
    
    output:
    tuple val(sample_id), path ('*.fasta'), emit: maxbin2_fastas, optional: true

    script:
    """
    run_MaxBin.pl \
    -contig $fasta_assembly \
    -reads ${trim_reads[0]} \
    -reads2 ${trim_reads[1]} \
    -out $sample_id

    set +e
    n_files=`find . -type f -name "*fa" | wc -l`
    if [[ \$n_files -eq 0 ]]; then
        touch maxbin2_${sample_id}_dummy.fa
    fi

    """
}

