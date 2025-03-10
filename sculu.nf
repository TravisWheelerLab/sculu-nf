#!/usr/bin/env nextflow

process sculu {
    input:
        path consensi
        path instances_dir

    output:
        path 'sculu-out/final.fa'

    container 'traviswheelerlab/sculu-rs:0.1.0'

    script:
    """
    sculu \
        --consensi     ${consensi} \
        --instances    ${instances_dir} \
        --align-matrix /usr/local/sculu/tests/inputs/matrices/25p41g.matrix \
        --outdir       sculu-out \
        --outfile      sculu-out/final.fa
    """
}

workflow {
    sculu(
	'/home/exouser/sculu/data/tuatara/consensi.fa',
	'/home/exouser/sculu/data/tuatara/instances'
    )
}
