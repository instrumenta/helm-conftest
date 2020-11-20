#!/usr/bin/env bash

set -euo pipefail

main() {
	HELM_BIN="${HELM_BIN:-helm}"

	output_dir="$(mktemp -d)"
	helm_options=()
	conftest_options=()

	if "${HELM_BIN}" plugin ls | grep -qF 'secrets-sops-driver'; then
		helm_options+=(secrets-sops-driver)
	fi

	if "${HELM_BIN}" plugin ls | grep -qF 'secrets'; then
		helm_options+=(secrets)
	fi

	helm_options+=(template)
	helm_options+=(--generate-name)
	helm_options+=(--output-dir "${output_dir}")

	while [ $# -ne 0 ]; do
		case "$1" in
		--version | --help)
			"${HELM_PLUGIN_DIR}/bin/conftest" "$1"
			exit
			;;
		--debug | --no-color | --trace | --update | --fail-on-warn | --combine)
			conftest_options+=("$1")
			shift
			;;
		--output | -o | --policy | -p | -d | --data)
			conftest_options+=("$1")
			conftest_options+=("$2")
			shift 2
			;;
		--policy-namespace)
			conftest_options+=("--namespace")
			conftest_options+=("$2")
			shift 2
			;;
		*)
			helm_options+=("$1")
			shift
			;;
		esac
	done

	"${HELM_BIN}" "${helm_options[@]}" >/dev/null

	# XXX: Find all the YAML files in the output directory. We cannot rely
	# on piping the output of "helm template" directly to conftest because
	# the secrets plugin may output to stdout as well. This workarounds
	# mimics the behavior of piping a YAML output stream directly to conftest.
	find "${output_dir}" -type f \( -iname '*.yml' -o -iname '*.yaml' \) -print0 \
		| xargs -0 cat \
		| "${HELM_PLUGIN_DIR}/bin/conftest" test "${conftest_options[@]}" -
}

main "$@"
