process BAKTA {
    publishDir "${params.outdir}/bakta", mode: "copy"
    
    input:
    path genomes

    output:
    "*"
    
    script:
    """
    bakta --db /fs/ess/PAS1568/databases/bakta/db \
    --gram ? \
    --force \
    $genomes
    """
}