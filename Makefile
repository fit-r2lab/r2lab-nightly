r2lab:
	rsync -ai nightly.py nightmail.py faraday:/tmp/r2lab-dev-embedded/
	@echo "on faraday:"
	@echo "conda activate r2lab-dev-313"
	@echo "BEWARE not to use /usr/bin/python but just plain python !!!"
	@echo "python /tmp/r2lab-dev-embedded/nightly.py"
