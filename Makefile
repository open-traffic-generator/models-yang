SHELL=bash


help:
	@awk -F ':|##' '/^[^\t].+:.*##/ { printf "\033[36mmake %-28s\033[0m -%s\n", $$1, $$NF }' $(MAKEFILE_LIST) | sort

default: lint ## default target is to just lint

setup: ## setup target just installs python and go requirements
	pip install --prefer-binary -r requirements.txt

lint: setup ## pyang lint target
	rm -rf artifacts
	mkdir -p artifacts
	for MODEL in `find models -type f -name *.yang`; do \
		OUTFILE=`basename -s .yang $$MODEL`; \
		pyang --strict --lint --format=tree --path=./models --output ./artifacts/$$OUTFILE.txt $$MODEL; \
	done

COMMON_ARGS = -path=./models -compress_paths=true -generate_fakeroot -fakeroot_name=device -generate_simple_unions -shorten_enum_leaf_names -typedef_enum_with_defmod -enum_suffix_for_simple_union_enums -trim_enum_openconfig_prefix -include_schema -generate_append -generate_getters -generate_rename -generate_delete -generate_leaf_getters -structs_split_files_count=3 -generate_populate_defaults
MODELS = `find models -name *.yang`
generate: lint ## go generation target
