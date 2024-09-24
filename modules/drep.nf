process DREP {
    publishDir "${params.outdir}/dRep_out", mode: "copy"
    
    input:
    tuple val(sample_id), path(concoct_fa), path(maxbin2_fa), path(metabat2_fa)

    output:
    tuple val(sample_id), path("${sample_id}_dRep_out/dereplicated_genomes"), emit: dereplicated_genomes

    script:
    """
    rm -f *_dummy.fa

    dRep dereplicate \
    "${sample_id}_dRep_out" \
    --ignoreGenomeQuality \
    -g *.f*a

    """
}
