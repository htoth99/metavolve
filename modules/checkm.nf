process CHECKM {
    publishDir "${params.outdir}/checkm", mode: "copy"
    
    input:
    tuple val(sample_id), path(genomes)

    output:
    path "checkm_out/${sample_id}_checkm_results.txt", emit: tabular_results

    script:
    """
    checkm lineage_wf -x .fa \
    -f checkm_out/${sample_id}_checkm_results.txt --tab_table \
    'dereplicated_genomes' \
    'checkm_out'
    """
}