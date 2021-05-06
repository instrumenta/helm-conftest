#! /bin/bash -e

HELM_BIN="${HELM_BIN:-helm}"

helm_options=()
conftest_options=()
eoo=0

while [[ $1 ]]
do
    if ! ((eoo)); then
        case "$1" in
            --version|--help)
                $HELM_PLUGIN_DIR/bin/conftest test $1
                exit
                ;;
            --debug|--no-color|--trace|--update|--fail-on-warn)
                conftest_options+=("$1")
                shift
                ;;
            --output|-o|--namespace|--policy|-p|--data|-d)
                conftest_options+=("$1")
                conftest_options+=("$2")
                shift 2
                ;;
            *)
                helm_options+=("$1")
                shift
                ;;
        esac
    else
        helm_options+=("$1")
        shift
    fi
done

render=$(${HELM_BIN} template "${helm_options[@]}")

echo "$render" | $HELM_PLUGIN_DIR/bin/conftest test - "${conftest_options[@]}"
