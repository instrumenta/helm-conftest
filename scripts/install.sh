#!/usr/bin/env bash

set -euo pipefail

main() {
	pushd "${HELM_PLUGIN_DIR}" >/dev/null

	version="$(grep "version" plugin.yaml | cut -d '"' -f 2)"

	echo "Installing helm-conftest v${version} ..."

	unameOut="$(uname -s)"

	case "${unameOut}" in
	Linux*)
		os=Linux
		;;
	Darwin*)
		os=Darwin
		;;
	*)
		echo "Unsupported OS: ${unameOut}" 1>&2
		return 1
		;;
	esac

	arch="$(uname -m)"
	url="https://github.com/open-policy-agent/conftest/releases/download/v${version}/conftest_${version}_${os}_${arch}.tar.gz"

	filename="$(mktemp)"

	if command -v curl >/dev/null; then
		curl --fail -sSL -o "${filename}" "${url}"
	elif command -v wget >/dev/null; then
		wget -q -O "${filename}" "${url}"
	else
		echo "Need curl or wget" 1>&2
		return 1
	fi

	rm -rf bin
	mkdir bin
	tar xzf "${filename}" -C bin
	rm -f "${filename}"

	echo "Checking conftest"
	bin/conftest --version

	echo "helm-conftest ${version} is installed."
	echo
	echo "See https://github.com/skillshare/helm-conftest for help getting started."
}

main "$@"
