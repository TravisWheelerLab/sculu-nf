TAG = sculu-rs:0.3.2

img:
	docker build --platform linux/amd64 --tag $(TAG) --no-cache .

shell:
	docker run -it -v $(shell pwd):/data --rm $(TAG) bash

push:
	docker tag $(TAG) traviswheelerlab/$(TAG)
	docker push traviswheelerlab/$(TAG)
