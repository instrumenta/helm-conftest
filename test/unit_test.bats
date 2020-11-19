#!/usr/bin/env bats

load vendor/bats-support/load
load vendor/bats-assert/load

setup() {
	export HELM_BIN=./test/bin/helm
	export HELM_PLUGIN_DIR=./test
}

@test "pipes helm template to conftest" {
	run scripts/run.sh
	assert_success

	assert [ "${lines[0]}" = "template" ]
	assert [ "${lines[1]}" = "--generate-name" ]
	assert [ "${lines[2]}" = "--output-dir" ]
	assert [ -d "${lines[3]}" ]

	assert [ "${lines[4]}" = "test" ]
	assert [ "${lines[5]}" = "-" ]
}

@test "--version goes to conftest" {
	run scripts/run.sh --version
	assert_success

	assert [ "${#lines[@]}" -eq 1 ]
	assert [ "${lines[0]}" = "--version" ]
}

@test "--help goes to conftest" {
	run scripts/run.sh --version
	assert_success

	assert [ "${#lines[@]}" -eq 1 ]
	assert [ "${lines[0]}" = "--version" ]
}

@test "conftest option forwarding" {
	local -a options=(--debug --no-color --trace --update --fail-on-warn --combine)

	for option in "${options[@]}"; do
		run scripts/run.sh "${option}"
		assert_success

		assert [ "${lines[0]}" = "template" ]
		assert [ "${lines[1]}" = "--generate-name" ]
		assert [ "${lines[2]}" = "--output-dir" ]
		assert [ -d "${lines[3]}" ]

		assert [ "${lines[5]}" = "${option}" ]
	done
}

@test "conftest option value forwarding" {
	local -a options=(--output -o --policy -p)

	for option in "${options[@]}"; do
		run scripts/run.sh "${option}" dummy
		assert_success

		assert [ "${lines[0]}" = "template" ]
		assert [ "${lines[1]}" = "--generate-name" ]
		assert [ "${lines[2]}" = "--output-dir" ]
		assert [ -d "${lines[3]}" ]

		assert [ "${lines[5]}" = "${option}" ]
		assert [ "${lines[6]}" = "dummy" ]
	done
}

@test "--policy-namespace" {
	run scripts/run.sh --policy-namespace dummy
	assert_success

	assert [ "${lines[0]}" = "template" ]
	assert [ "${lines[1]}" = "--generate-name" ]
	assert [ "${lines[2]}" = "--output-dir" ]
	assert [ -d "${lines[3]}" ]

	assert [ "${lines[5]}" = "--namespace" ]
	assert [ "${lines[6]}" = "dummy" ]
}

@test "helm argument forwarding" {
	run scripts/run.sh --foo bar
	assert_success

	assert [ "${lines[0]}" = "template" ]
	assert [ "${lines[1]}" = "--generate-name" ]
	assert [ "${lines[2]}" = "--output-dir" ]
	assert [ -d "${lines[3]}" ]
	assert [ "${lines[4]}" = "--foo" ]
	assert [ "${lines[5]}" = "bar" ]
}

@test "uses the secrets plugin if available" {
	run env HELM_PLUGINS=secrets scripts/run.sh
	assert_success

	assert [ "${lines[0]}" = "secrets" ]
	assert [ "${lines[1]}" = "template" ]
	assert [ "${lines[2]}" = "--generate-name" ]
	assert [ "${lines[3]}" = "--output-dir" ]
	assert [ -d "${lines[4]}" ]

	assert [ "${lines[5]}" = "test" ]
	assert [ "${lines[6]}" = "-" ]

}
