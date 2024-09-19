process ASSEMBLYINDEX {
    publishDir "${params.outdir}/assemblyindex", mode: 'copy'
    cpus 8
    
    input:
    //tuple val(sample_id), path(trim_reads)
    tuple val(sample_id), path(fasta_assembly), path(trim_reads) 

    output:
    tuple val(sample_id),
        path("${sample_id}.bam"),
        path("${sample_id}.bam.bai"),
        path("${sample_id}.bed")

    script:
    """
    bwa index -p "$sample_id" "$fasta_assembly"

    bwa mem -t $task.cpus -a "$sample_id" \
    ${trim_reads[0]} ${trim_reads[1]} > "$sample_id".sam

    samtools view -b -S "$sample_id".sam > "$sample_id".bam
    rm "$sample_id".sam

    samtools sort -o "$sample_id"_sorted.bam "$sample_id".bam
    rm "$sample_id".bam

    mv "$sample_id"_sorted.bam "$sample_id".bam
    samtools index "$sample_id".bam

    bedtools bamtobed -i "$sample_id".bam > "$sample_id".bed
    """
}
