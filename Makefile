.PHONY: all
all: tests

.PHONY: bootstrap
bootstrap:
	Scripts/bootstrap

.PHONY: build
build:
	Scripts/build

.PHONY: changelog
changelog:
	Scripts/changelog

.PHONY: dependencies
dependencies:
	Scripts/dependencies

.PHONY: formatter
formatter:
	Scripts/formatter

.PHONY: setup
setup:
	Scripts/setup

.PHONY: tests
tests:
	Scripts/tests

.PHONY: xcproject
xcproject:
	Scripts/xcproject

