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
include { CONCOCT } from './modules/concoct.nf'
include { DREP } from './modules/drep.nf'

workflow {
    // prepare params
    paired_reads_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)
    reads_ch = paired_reads_ch.flatten().filter(~/.*fastq.*/ )
    host_ref_ch = Channel.fromPath(params.genome_ref).first()
    krakendb_ch = Channel.fromPath(params.kraken_db, type: 'dir')

    // quality control and trimming
    fastqc_ch = FASTQC(reads_ch)
    trim_ch = TRIMGALORE(paired_reads_ch)

    // index the host, if needed, then remove host
    host_index_ch = params.genome_index ? Channel.fromPath(params.genome_index) : (HOSTINDEX(host_ref_ch))
    host_remove_ch = HOSTREMOVE(host_index_ch, trim_ch)

    // taxonomic classifier
    kraken_ch = KRAKEN2(host_remove_ch, params.kraken_db)

    // assembly related channels
    assembly_ch = ASSEMBLY(host_remove_ch)
    assembly_index_ch = ASSEMBLYINDEX(trim_ch, assembly_ch.fasta_scaffold)
    asm_all_ch = assembly_ch.fasta_scaffold.join(assembly_index_ch)
    asm_all_reads_ch = asm_all_ch.join(trim_ch)
    //asm_all_reads_ch.view()

    // binners
    concoct_ch = CONCOCT(asm_all_ch)
    maxbin2_ch = MAXBIN2(asm_all_reads_ch)
    metabat2_ch = METABAT2(asm_all_ch)
    bins_ch = concoct_ch.concoct_fastas.join(maxbin2_ch.maxbin2_fastas).join(metabat2_ch.metabat2_fastas)


    // deprelicate and checkm
    drep_ch = DREP(bins_ch)
}
