process BINNING {
    cpus 2

    input:
    tuple val(sample_id), path(reads)
    path fasta_assembly

    output:
    path '*'

    script:
    """
    metawrap binning \
    -a $fasta_assembly \
    -m $task.memory -t $task.cpus \
    --maxbin2 --concoct --metabat2 \
    -o $sample_id \
    ${reads[0]} ${reads[1]}
    """
}

            withName: 'METAWRAP' {
                conda = 'bioconda::metawrap-mg'
                executor = 'slurm'
                time = 4.hour
                memory = 50.GB
                clusterOptions = '-A PAS1568'
            }

withName: 'BINNING' {
                container = 'oras://community.wave.seqera.io/library/metawrap:1.2--fca66080dfae2376'
                executor = 'slurm'
                time = 5.hour
                memory = 50.GB
                clusterOptions = '-A PAS1568'
            }

    extract_fasta_bins.py $fasta_assembly merged.csv --output "$sample_id"

    # count fasta files in outdir, then pass to a txt file, then pass that txt file to another file that counts it
    # other downstream files might have the answer