process HOSTREMOVE {

    input:
    path(host_index_dir)
    tuple val(sample_id), path(trimmed_reads)

    output:
    tuple val(sample_id), path('*.fastq')

    shell:
    '''
    index_prefix=$(ls !{host_index_dir} | head -n1 | sed -E "s/.[0-9]+.bt2//")
    index_prefix_full=!{host_index_dir}/$index_prefix

    bowtie2 \
        -x $index_prefix_full \
        -1 !{trimmed_reads[0]} \
        -2 !{trimmed_reads[1]} \
        --local \
        --un-conc \
        !{sample_id}_host_removed_reads \
        > !{sample_id}_mapped_unmapped.sam

    mv !{sample_id}_host_removed_reads.1 !{sample_id}_hostrm_R1.fastq
    mv !{sample_id}_host_removed_reads.2 !{sample_id}_hostrm_R2.fastq
    '''
}