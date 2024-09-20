process KRAKEN2 {
    publishDir "${params.outdir}/kraken_results", mode: "copy"

    input:
    tuple val(sample_id), path(reads)
    path database

    output:
    path '*.kreport'
    path '*.kraken'

    script:
    """
    kraken2 --db $database \
    --report ${sample_id}.kreport \
    --output ${sample_id}.kraken \
    ${reads[0]} ${reads[1]}
    """
}