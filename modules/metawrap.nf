process METAWRAP {
    cpus 2

    input:
    tuple val(sample_id), path(reads)
    path fasta_assembly

    output:
    path '*'

    script:
    """
    metawrap binning \
    -a $fasta_assembly \
    -m $task.memory -t $task.cpus \
    --maxbin2 --concoct --metabat2 \
    -o $sample_id \
    ${reads[0]} ${reads[1]}
    """
}