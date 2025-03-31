process KRAKENBIOM {
    publishDir "${params.outdir}/biom", mode: "copy"

    input:
    path kreports

    output:
    '*'

    script:
    """
    kraken-biom $kreports \
    --fmt json -o kraken.biom
    """
}