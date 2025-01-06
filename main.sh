#!/bin/bash
#SBATCH -A PAS1568
#SBATCH --time=30:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --output=metavolvetest-%j.out

set -euo pipefail

nextflow run main.nf -ansi-log false -resume -profile standard "$@"
