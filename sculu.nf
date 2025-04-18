#!/usr/bin/env nextflow

workflow {
    make_components(
        params.consensi, 
        params.instances, 
        params.config, 
        params.alphabet
    )

    process_components(
        params.config, 
        make_components.out.consensi, 
        make_components.out.instances_dir, 
        make_components.out.components.flatten(),
        params.alphabet
    )

    concatenate(
        make_components.out.consensi, 
        make_components.out.singletons, 
        make_components.out.components,
        params.outfile
    )
}

// --------------------------------------------------
process make_components {
    publishDir 'results', mode: 'copy'

    input:
        path consensi
        path instances_dir
        path config
        val  alphabet

    output:
        path 'sculu-out/components/component-*', emit: components
        path 'sculu-out/components/singletons', emit: singletons, optional: true
        path 'sculu-out/consensi.fa', emit: consensi
        path 'sculu-out/instances', emit: instances_dir
        path 'sculu-out/debug.log', emit: logfile
        path 'sculu-out/consensi_cluster/blast.tsv', emit: consensi_blast

    container 'traviswheelerlab/sculu-rs:0.3.1'

    script:
    """
    sculu \
        components \
        --alphabet     ${alphabet} \
        --config       ${config} \
        --consensi     ${consensi} \
        --instances    ${instances_dir} \
        --align-matrix /usr/local/sculu/tests/inputs/matrices/25p41g.matrix \
        --outdir       sculu-out \
        --outfile      sculu-out/final.fa
    """
}

// --------------------------------------------------
process process_components {
    publishDir 'results', mode: 'copy'

    input:
        path config
        path consensi
        path instances_dir
        path component
        val  alphabet

    output:
        path "sculu-out/${component}/final.fa", emit: merged
        path "sculu-out/${component}.log"

    container 'traviswheelerlab/sculu-rs:0.3.1'

    script:
    """
    sculu \
        cluster \
        --config       ${config} \
        --alphabet     ${alphabet} \
        --consensi     ${consensi} \
        --instances    ${instances_dir} \
        --component    ${component} \
        --outdir       sculu-out/ \
        --logfile      sculu-out/${component}.log \
        --outfile      sculu-out/${component}/final.fa
    """
}

// --------------------------------------------------
process concatenate {
    publishDir 'results', mode: 'copy'

    input:
        path consensi
        path singletons
        path components
        path outfile

    output:
        path "sculu-out/families.fa", emit: families

    container 'traviswheelerlab/sculu-rs:0.3.1'

    script:
    """
    sculu \
        concat \
        --consensi     ${consensi} \
        --singletons   ${singletons} \
        --components   ${components} \
        --outdir       sculu-out/ \
        --logfile      sculu-out/${component}.log \
        --outfile      ${outfile}
    """
}
