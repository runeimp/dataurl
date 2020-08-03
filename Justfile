


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


