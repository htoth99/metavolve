process CONCOCT {
    
    input:
    tuple val(sample_id), path(fasta_assembly), path(bam_file), path(bam_index), path(bed_file)

    output:
    tuple val(sample_id), path ('fasta_bins/*.fa'), emit: concoct_fastas, optional: true

    script:
    """
    cp "$bed_file" copy.bed

    cut_up_fasta.py $fasta_assembly -c 100000 --merge_last -b copy.bed > contigs10k.fasta

    concoct_coverage_table.py copy.bed $bam_file > covtable.tsv

    concoct --composition_file contigs10k.fasta --coverage_file covtable.tsv -s 100

    merge_cutup_clustering.py clustering_gt1000.csv > merged.csv

    mkdir fasta_bins
    extract_fasta_bins.py $fasta_assembly merged.csv --output_path fasta_bins

    set +e
    n_files=`find . -type f -name "*fa" | wc -l`
    if [[ \$n_files -eq 0 ]]; then
        touch concoct_${sample_id}_dummy.fa
    fi
    """
}
