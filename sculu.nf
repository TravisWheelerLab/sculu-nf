#!/usr/bin/env nextflow

workflow {
    make_components(params.consensi, params.instances)

    process_components(
        make_components.out.consensi, 
        make_components.out.instances_dir, 
        make_components.out.components.flatten()
    )
}

// --------------------------------------------------
process make_components {
    publishDir 'results', mode: 'copy'

    input:
        path consensi
        path instances_dir

    output:
        path 'sculu-out/components/component-*', emit: components
        path 'sculu-out/components/singletons', emit: singletons, optional: true
        path 'sculu-out/consensi.fa', emit: consensi
        path 'sculu-out/instances', emit: instances_dir
        path 'sculu-out/debug.log', emit: logfile
        path 'sculu-out/consensi_cluster/blast.out', emit: consensi_blast

    container 'traviswheelerlab/sculu-rs:0.1.0'

    script:
    """
    sculu \
        --build-components-only \
        --consensi     ${consensi} \
        --instances    ${instances_dir} \
        --align-matrix /usr/local/sculu/tests/inputs/matrices/25p41g.matrix \
        --outdir       sculu-out \
        --outfile      sculu-out/final.fa
    """
}

// --------------------------------------------------
process process_components {
    publishDir 'results', mode: 'cope'

    input:
        path consensi
        path instances_dir
        path component

    output:
        path "sculu-out/${component}/final.fa"
        path "sculu-out/${component}.log"

    container 'traviswheelerlab/sculu-rs:0.1.0'

    script:
    """
    sculu \
        --consensi     ${consensi} \
        --instances    ${instances_dir} \
        --component    ${component} \
        --align-matrix /usr/local/sculu/tests/inputs/matrices/25p41g.matrix \
        --outdir       sculu-out/ \
        --logfile      sculu-out/${component}.log \
        --outfile      sculu-out/${component}/final.fa
    """
}
