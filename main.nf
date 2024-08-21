params.reads = "$projectDir/data/rawreads/*_R{1,2}.fastq"
params.genome_ref = "/fs/scratch/PAS1568/htoth99/bsmgs/fl-insillico/rawdata/plant_genomes/subset/subset_Slycopersicum_225.fa"
params.kraken_db = "/users/PAS1568/htoth99/programs/kraken2/k2-pluspf"
params.genome_index = null
params.outdir = "$projectDir/results"

log.info """
    ==============================================
    Metagenomic Plant Pathogen Diagnostic Pipeline
    ==============================================
    reads: ${params.reads}
    reference genome to be indexed: ${params.genome_ref}
    outdir: ${params.outdir}
""".stripIndent(true)

// Import modules
include { FASTQC } from './modules/fastqc.nf'
include { TRIMGALORE } from './modules/trimgalore.nf'
include { HOSTINDEX } from './modules/hostindex.nf'
include { HOSTREMOVE } from './modules/hostremove.nf'
include { ASSEMBLY } from './modules/assembly.nf'
include { KRAKEN2 } from './modules/kraken2.nf'
include { ASSEMBLYINDEX } from './modules/assemblyindex.nf'
include { MAXBIN2 } from './modules/maxbin2.nf'
include { METABAT2 } from './modules/metabat2.nf'
//include { CONCOCT } from './modules/concoct.nf'

workflow {
    // reads_ch = Channel.fromPath(params.reads, checkIfExists: true)
    paired_reads_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)
    reads_ch = paired_reads_ch.flatten().filter(~/.*fastq.*/ )
    host_ref_ch = Channel.fromPath(params.genome_ref)
    krakendb_ch = Channel.fromPath(params.kraken_db, type: 'dir')

    fastqc_ch = FASTQC(reads_ch)
    trim_ch = TRIMGALORE(paired_reads_ch)

    host_index_ch = params.genome_index ? Channel.fromPath(params.genome_index) : (HOSTINDEX(host_ref_ch))

    host_remove_ch = HOSTREMOVE(host_index_ch, trim_ch)
    kraken_ch = KRAKEN2(host_remove_ch, params.kraken_db)

    assembly_ch = ASSEMBLY(host_remove_ch)

    assembly_index_ch = ASSEMBLYINDEX(trim_ch, assembly_ch.fasta_assembly)

    //concoct_ch = CONCOCT(assembly_ch.fasta_assembly, assembly_index_ch)

    maxbin2_ch = MAXBIN2(host_remove_ch, assembly_ch.fasta_assembly)
    metabat2_ch = METABAT2(assembly_index_ch.bam_file, assembly_ch.fasta_assembly)
    //binning_ch = METAWRAP(host_remove_ch, assembly_ch.fasta_assembly)

}
