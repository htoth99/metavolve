process BAKTA {
    publishDir "${params.outdir}/bakta", mode: "copy"
    
    input:
    path genomes

    output:
    path '*.faa', emit: protein_files
    path '*.fna'
    path '*.gbff'
    path '*.gff3'
    path '*.ffn'
    
    script:
    """
    bakta --db /fs/ess/PAS1568/databases/bakta/db \
    --gram ? \
    --force \
    $genomes

    rm *.hypotheticals.faa
    """
}