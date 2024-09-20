process DREP {
    publishDir "${params.outdir}/dRep_results", mode: "copy"
    //publishDir "${params.outdir}/checkM_infotables", mode: "copy", pattern:"data_tables"
    //publishDir "${params.outdir}/dereplicated_genomes", mode: "copy", pattern:"dereplicated_genomes"
    //publishDir "${params.outdir}/checkM_result", mode: "copy", pattern:"results.tsv"
    
    input:
    tuple val(sampled_id), path(concoct_fa), path(maxbin2_fa), path(metabat2_fa)

    output:
    path 'data_tables', emit: checkM_infotables, optional: true
    path 'dereplicated_genomes', emit: depreplicated_genomes, optional: true
    path 'data/checkM/checkM_outdir/results.tsv', emit: checkM_result, optional: true
    // flexible, probably best to specify what you want right here rather than down the line

    script:
    """
    dRep dereplicate \
    'drep_out' \
    -g *.f*a
    """
}