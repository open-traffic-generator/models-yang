default: lint

setup:
	pip install -r requirements.txt

lint: setup
	rm -rf artifacts
	mkdir -p artifacts
	for MODEL in `find models -type f -name *.yang`; do \
		OUTFILE=`basename -s .yang $$MODEL`; \
		pyang --strict --lint --format=tree --path=./models --output ./artifacts/$$OUTFILE.txt $$MODEL; \
	done

