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
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install github.com/openconfig/ygot/generator@latest
	go install golang.org/x/tools/cmd/goimports@latest

	rm -rf pkg/telemetry && mkdir -p pkg/telemetry/device
	generator \
		-generate_structs \
		-generate_path_structs=false \
		-prefer_operational_state \
		-list_builder_key_threshold=4 \
		-output_dir=pkg/telemetry \
		-package_name=telemetry \
		-path_structs_split_files_count=2 \
		${COMMON_ARGS} \
		${MODELS}

	generator \
		-generate_structs=false \
		-generate_path_structs=true \
		-prefer_operational_state \
		-list_builder_key_threshold=4 \
		-output_dir=pkg/telemetry \
		-package_name=device \
		-path_structs_output_file=pkg/telemetry/device/device.go \
		-split_pathstructs_by_module=true \
		-schema_struct_path=github.com/open-traffic-generator/ixia-c-gnmi-server/pkg/telemetry \
		-path_struct_package_suffix="" \
		-base_import_path=github.com/open-traffic-generator/ixia-c-gnmi-server/pkg/telemetry \
		-path_structs_split_files_count=2 \
		$(COMMON_ARGS) \
		${MODELS}

	find pkg/telemetry -name "*.go" -exec goimports -w {} +
	find pkg/telemetry -name "*.go" -exec gofmt -w -s {} +
