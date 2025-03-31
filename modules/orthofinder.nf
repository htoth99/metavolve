process ORTHOFINDER {

    input:
    file faa_files

    output:
    path '*'

    script:
    """
    mkdir -p protein_files_folder
    mv -v *.faa protein_files_folder

    orthofinder \
    -M msa -T fasttree \
    -f protein_files_folder
    """
}
