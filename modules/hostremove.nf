process HOSTREMOVE {
    cpus 16

    input:
    tuple val(host_index), path(host_index_reads)
    tuple val(sample_id), path(trimmed_reads)

    output:
    tuple val(sample_id), path('*.fastq')

    script:
    """
    bowtie2 -p $task.cpus -x $host_index \
    -1 ${trimmed_reads[0]} \
    -2 ${trimmed_reads[1]} \
    --local \
    --un-conc \
    ${sample_id}_host_removed_reads \
    > ${sample_id}_mapped_unmapped.sam

    mv ${sample_id}_host_removed_reads.1 ${sample_id}_hostrm_R1.fastq
    mv ${sample_id}_host_removed_reads.2 ${sample_id}_hostrm_R2.fastq
    """
}