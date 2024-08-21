process ASSEMBLYINDEX {
    publishDir "${params.outdir}/assemblyindex", mode: 'copy'
    cpus 8
    
    input:
    tuple val(sample_id), path(reads)
    path fasta_assembly

    output:
    path "${sample_id}.bam", emit: bam_file
    path "${sample_id}.bam.bai", emit: index_bam
    path "${sample_id}.bed", emit: bed_file

    script:
    """
    bwa index -p "$sample_id" "$fasta_assembly"

    bwa mem -t $task.cpus -a "$sample_id" \
    ${reads[0]} ${reads[1]} > "$sample_id".sam

    samtools view -b -S "$sample_id".sam > "$sample_id".bam
    rm "$sample_id".sam

    samtools sort -o "$sample_id"_sorted.bam "$sample_id".bam
    rm "$sample_id".bam

    mv "$sample_id"_sorted.bam "$sample_id".bam
    samtools index "$sample_id".bam

    bedtools bamtobed -i "$sample_id".bam > "$sample_id".bed
    """
}
