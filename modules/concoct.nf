process CONCOCT {
    input:
    path bam_file
    path indexed_bam
    val bed_file
    val fasta_assembly

    output:
    path ('*.fa')

    script:
    """
    cut_up_fasta.py "$fasta_assembly" -c 100000 --merge_last -b "$bed_file" > contigs10k.fasta

    concoct_coverage_table.py "$bed_file" "$bam_file" > covtable.tsv

    concoct --composition_file contigs10k.fasta --coverage_file covtable.tsv -s 100

    merge_cutup_clustering.py clustering_gt1000.csv > merged.csv

    extract_fasta_bins.py $fasta_assembly
    """
}
