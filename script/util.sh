# shellcheck shell=bash

log::header() {
	echo '=>' "$@" 1>&2
}

log::indicator() {
	echo '->' "$@" 1>&2
}

log::debug() {
	if tput colors &>/dev/null; then
		# XXX: Light gray color
		echo -e "\033[1;30m-> $*\033[0m" 1>&2
	else
		echo '->' "$@" 1>&2
	fi
}

log::error() {
	if tput colors &>/dev/null; then
		# XXX: Red
		echo -e "\033[31mERROR: $*\033[0m" 1>&2
	else
		echo "ERROR:" "$@" 1>&2
	fi
}

log::warn() {
	if tput colors &>/dev/null; then
		# XXX: bright yellow
		echo -e "\033[1;33m-> $*\033[0m" 1>&2
	else
		echo "->" "$@" 1>&2
	fi
}

log::success() {
	if tput colors &>/dev/null; then
		# XXX: green
		echo -e "\033[32m-> $*\033[0m" 1>&2
	else
		echo "->" "$@" 1>&2
	fi
}

log::exec_command() {
	log::debug '$' "$@"
	"$@"
}
