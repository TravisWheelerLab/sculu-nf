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
        make_components.out.alignments, 
        make_components.out.instances_dir, 
        make_components.out.components.flatten(),
        params.alphabet
    )

    concatenate(
        make_components.out.consensi, 
        make_components.out.singletons, 
        process_components.out.merged,
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
        path 'sculu-out/components/alignment.tsv', emit: alignments
        path 'sculu-out/consensi.fa', emit: consensi
        path 'sculu-out/instances', emit: instances_dir
        path 'sculu-out/debug.log', emit: logfile
        path 'sculu-out/consensi_cluster/blast.tsv', emit: consensi_blast

    container 'traviswheelerlab/sculu-rs:0.3.2'

    script:
    """
    sculu \
        --logfile   sculu-out/debug.log \
        components  \
        --alphabet  ${alphabet} \
        --config    ${config} \
        --consensi  ${consensi} \
        --instances ${instances_dir} \
        --outdir    sculu-out
    """
}

// --------------------------------------------------
process process_components {
    publishDir 'results', mode: 'copy'

    input:
        path config
        path consensi
        path alignments
        path instances_dir
        path component
        val  alphabet

    output:
        path "sculu-out/${component}/final.fa", emit: merged
        path "sculu-out/${component}.log", emit: log

    container 'traviswheelerlab/sculu-rs:0.3.2'

    script:
    """
    sculu \
        --logfile   sculu-out/${component}.log \
        cluster \
        --config     ${config} \
        --alphabet   ${alphabet} \
        --consensi   ${consensi} \
        --alignments ${alignments} \
        --instances  ${instances_dir} \
        --component  ${component} \
        --outdir     sculu-out/ \
    """
}

// --------------------------------------------------
process concatenate {
    publishDir 'results', mode: 'copy'

    input:
        path consensi
        path singletons
        path components

    output:
        path "sculu-out/families.fa", emit: families
        path "sculu-out/concat.log", emit: concat_log

    container 'traviswheelerlab/sculu-rs:0.3.2'

    script:
    """
    sculu \
        --logfile    sculu-out/concat.log \
        concat \
        --consensi   ${consensi} \
        --singletons ${singletons} \
        --components ${components} \
        --outfile    sculu-out/families.fa
    """
}
