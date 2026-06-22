#!/bin/sh
set -eu

workflow=.github/workflows/build-packages.yml
readme=README.md

fail() {
	printf '%s\n' "$*" >&2
	exit 1
}

[ -f "$workflow" ] || fail "missing $workflow"

grep -Eq 'openwrt/gh-action-sdk' "$workflow" ||
	fail "workflow must build with openwrt/gh-action-sdk"

grep -Eq 'aarch64_cortex-a53' "$workflow" ||
	fail "workflow must build aarch64_cortex-a53 packages"

grep -Eq '\.apk|package_ext: apk|name: apk' "$workflow" ||
	fail "workflow must collect APK packages"

grep -Eq '\.ipk|package_ext: ipk|name: ipk' "$workflow" ||
	fail "workflow must keep IPK packages"

grep -Eq 'gh release upload|softprops/action-gh-release' "$workflow" ||
	fail "workflow must publish packages on tagged releases"

grep -Eq 'apk add' "$readme" ||
	fail "README must document apk installation"

grep -Eq 'opkg install' "$readme" ||
	fail "README must keep opkg installation"
