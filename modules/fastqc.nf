process FASTQC {
    publishDir "${params.outdir}/fastqc", mode: "copy"

    input:
    path sample

    output:
    path '*.html'

    script:
    """
    module load fastqc
    fastqc "$sample"
    """
}