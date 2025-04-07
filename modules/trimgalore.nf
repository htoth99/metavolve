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

    for i in ./*.f*; do
        if [[ $i == *.fq ]]; then
            mv $sample_id/*_val_1.fq $sample_id/${sample_id}_R1.fastq
            mv $sample_id/*_val_2.fq $sample_id/${sample_id}_R2.fastq
        elif [[ $i == *.fq.gz ]]; then
            mv $sample_id/*_val_1.fq.gz $sample_id/${sample_id}_R1.fastq.gz
            mv $sample_id/*_val_2.fq.gz $sample_id/${sample_id}_R2.fastq.gz
        fi
    done
    """

}