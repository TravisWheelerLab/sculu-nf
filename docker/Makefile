TAG = sculu:stable

img:
	docker build . --platform linux/amd64 --tag $(TAG)

shell:
	docker run -it --rm $(TAG) bash
