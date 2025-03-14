run:
	nextflow run sculu.nf -resume \
	    --consensi /Users/kyclark/wheelerlab/sculu/rust/data/tuatara/consensi.fa \
	    --instances /Users/kyclark/wheelerlab/sculu/rust/data/tuatara/instances

clean:
	rm -rf .nextflow.log* work results

runout:
	nextflow run sculu.nf -output-dir results
