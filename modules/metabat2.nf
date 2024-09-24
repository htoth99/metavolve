process METABAT2 {
    input:
    tuple val(sample_id), path(fasta_assembly), path(bam_file), path(bam_index), path(bed_file)

    output:
    tuple val(sample_id), path ('*.fa'), emit: metabat2_fastas, optional: true


    script:
    """

    jgi_summarize_bam_contig_depths --outputDepth depth.txt $bam_file

    metabat2 -i $fasta_assembly -a depth.txt -m 1500 --maxP 75 -s 100000 -o $sample_id

    set +e
    n_files=`find . -type f -name "*fa" | wc -l`
    if [[ \$n_files -eq 0 ]]; then
        touch metabat_${sample_id}_dummy.fa
    fi

    """
}