#!/usr/bin/env bats

load vendor/bats-support/load
load vendor/bats-assert/load

setup() {
	export HELM_DATA_HOME=${BATS_TMP_DIR}

	run helm plugin ls
	assert_success

	# Install the plugin once for all tests
	if ! echo "${output[@]}" | grep -qF 'conftest'; then
		run helm plugin install .
		assert_success
	fi

	run helm plugin ls
	assert_output --partial 'conftest'
}

@test "basic user flow" {
	run helm conftest test/sample -p test/policy
	assert_success
}

@test "version checking" {
	run helm conftest --version
	assert_success
	assert_output --partial '0.22.0'
}
