run:
	nextflow run sculu.nf -profile local \
	    --consensi /Users/kyclark/wheelerlab/sculu/rust/data/tuatara/consensi.fa \
	    --instances /Users/kyclark/wheelerlab/sculu/rust/data/tuatara/instances

hpctua:
	nextflow run sculu.nf -profile hpc \
	    --consensi /home/u20/kyclark/work/data/tuatara/consensi.fa \
	    --instances /home/u20/kyclark/work/data/tuatara/instances

hpcalu:
	nextflow run sculu.nf -profile hpc \
	    --consensi /home/u20/kyclark/work/data/alu/consensi.fa \
	    --instances /home/u20/kyclark/work/data/alu/instances

clean:
	rm -rf .nextflow.log* work results

runout:
	nextflow run sculu.nf -output-dir results

img:
	apptainer build sculu.sif docker://traviswheelerlab/sculu-rs:0.1.0
