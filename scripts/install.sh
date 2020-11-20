#!/usr/bin/env bash

set -euo pipefail

declare -r CONFTEST_VERSION=0.22.0

main() {
	pushd "${HELM_PLUGIN_DIR}" >/dev/null

	echo "Installing helm-conftest v${CONFTEST_VERSION} ..."

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
	url="https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_${os}_${arch}.tar.gz"

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

	echo "conftest ${CONFTEST_VERSION} is installed."
	echo
	echo "See https://github.com/skillshare/helm-conftest for help getting started."
}

main "$@"
