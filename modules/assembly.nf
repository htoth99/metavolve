process ASSEMBLY {

    
    input:
    tuple val(sample_id), path(removed_reads)

    output:
    tuple val(sample_id), path ("$sample_id/${sample_id}.fasta"), emit: fasta_contig
    tuple val(sample_id), path ("$sample_id/${sample_id}_scaffolds.fasta"), emit: fasta_scaffold
    tuple val(sample_id), path ("$sample_id/${sample_id}_spades.log")

    script:
    """
    spades.py \
    -1 ${removed_reads[0]} \
    -2 ${removed_reads[1]} \
    -o $sample_id --only-assembler --meta

    mv $sample_id/contigs.fasta $sample_id/${sample_id}.fasta
    mv $sample_id/scaffolds.fasta $sample_id/${sample_id}_scaffolds.fasta
    mv $sample_id/spades.log $sample_id/${sample_id}_spades.log
    """
}