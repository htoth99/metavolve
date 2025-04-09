process TRIMGALORE {

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("$sample_id/*.fastq*")
    
    script:
    """
    trim_galore \
    --paired \
    --illumina \
    --output_dir $sample_id \
    ${reads[0]} ${reads[1]}

    trim_loop.sh
    """

}