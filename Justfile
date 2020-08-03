#
# dataURL Justfile
#
APP_NAME := 'dataURL'
CLI_NAME := 'dataurl'
MAIN_CODE := 'main.go'
ZIP_NAME := 'dataURL'


@_default:
	just _term-wipe
	just --list


# Build the target platform
build target='mac':
	just _term-wipe
	just _build-{{target}}

_build-mac:
	rm -rf bin/macos
	mkdir -p bin/macos
	
	go build -ldflags="-s -w" -o bin/macos/dataurl *.go
	@# bin/macos/dataurl example.html

_build-win:
	rm -rf bin/windows
	mkdir -p bin/windows

	GOOS=windows GOARCH=amd64 go build -ldflags="-s -w" -o bin/windows/dataurl.exe
	@# bin/windows/dataurl.exe example.html


# Create a Zip file based on a directory
dirzip path:
	ditto -ck --keepParent --zlibCompressionLevel 9 --norsrc --noqtn --nohfsCompression "{{path}}" "{{path}}.zip"


# Archive GoReleaser App Distribution
dist-archive:
	#!/bin/bash
	just _term-wipe
	mkdir -p "${PWD}/distro"
	version="$(just version)"
	distro_path="${PWD}/distro/{{ZIP_NAME}}-v${version}"
	echo "\${PWD}/distro = ${PWD}/distro"
	echo "version = ${version}"
	echo "distro_path = ${distro_path}"
	# mv dist "${distro_path}"
	ls -Ahl "${distro_path}/"*

# Build App Distribution
dist-build:
	#!/bin/bash
	just _term-wipe
	version="$(just version)"
	distro_path="${PWD}/distro/{{ZIP_NAME}}-v${version}"
	linux_distro="${distro_path}/{{ZIP_NAME}}-v${version}-linux"
	macos_distro="${distro_path}/{{ZIP_NAME}}-v${version}-macos"
	windows_distro="${distro_path}/{{ZIP_NAME}}-v${version}-windows"

	echo "distro_path = ${distro_path}"
	echo "linux_distro = ${linux_distro}"
	echo "macos_distro = ${macos_distro}"
	echo "windows_distro = ${windows_distro}"

	[[ -d "${distro_path}"  ]] && rm -rf "${distro_path}/*"

	mkdir -p "${linux_distro}"
	mkdir -p "${macos_distro}"
	mkdir -p "${windows_distro}"

	GOOS=linux GOARCH=amd64 go build -o "${linux_distro}/{{CLI_NAME}}" main.go
	GOOS=darwin GOARCH=amd64 go build -o "${macos_distro}/{{CLI_NAME}}" main.go
	GOOS=windows GOARCH=amd64 go build -o "${windows_distro}/{{CLI_NAME}}.exe" main.go

	cp README.md "${linux_distro}/"
	cp README.md "${macos_distro}/"
	cp README.md "${windows_distro}/"

	just dirzip "${linux_distro}"
	just dirzip "${macos_distro}"
	just dirzip "${windows_distro}"

	ls -Ahl "${distro_path}/"*


# Run app on this platform
run +src='example.html':
	just _term-wipe
	go run main.go -d {{src}}


# Wipes the terminal buffer for a clean start
_term-wipe:
	#!/bin/sh
	if [[ ${#VISUAL_STUDIO_CODE} -gt 0 ]]; then
		clear
	elif [[ ${KITTY_WINDOW_ID} -gt 0 ]] || [[ ${#TMUX} -gt 0 ]] || [[ "${TERM_PROGRAM}" = 'vscode' ]]; then
		printf '\033c'
	elif [[ "$(uname)" == 'Darwin' ]] || [[ "${TERM_PROGRAM}" = 'Apple_Terminal' ]] || [[ "${TERM_PROGRAM}" = 'iTerm.app' ]]; then
		osascript -e 'tell application "System Events" to keystroke "k" using command down'
	elif [[ -x "$(which tput)" ]]; then
		tput reset
	elif [[ -x "$(which reset)" ]]; then
		reset
	else
		clear
	fi


# Display version of app
version:
	#!/bin/sh
	cat "{{MAIN_CODE}}" | grep -E '^\tappVersion' | cut -d'"' -f 2

