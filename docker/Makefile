TAG = sculu-rs:0.1.0

img:
	docker build --platform linux/amd64 --tag $(TAG) --no-cache .

shell:
	docker run -it -v $(shell pwd):/data --rm $(TAG) bash

push:
	docker push $(TAG)
