process METABAT2 {
    input:
    path fasta_assembly
    path bam_file

    output:
    path ('*.fa')

    script:
    """
    jgi_summarize_bam_contig_depths --outputDepth depth.txt "$bam_file"

    metabat2 -i "$fasta_assembly" -a depth.txt -o metabat2out
    """
}