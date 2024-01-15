.PHONY: help usage clean format test report docs prepublish

help: 		## This help dialog.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

clean: 		## Cleans the project.
	@echo '>> 🗑️ Cleaning the project...'
	@rm -rf pubspec.lock .dart_tool coverage doc
	@echo '>> 🎉 Done!'

install: 	## Installs dependencies.
	@echo '>> ⬇️ Installing dependencies...'
	@dart pub get

format: 	## Formats the codebase.
	@echo '>> 📂 Formatting codebase...'
	@dart format lib
	@dart analyze || (echo '▓▓ Lint errors ▓▓'; exit 1)

usage: 		## Runs the example.
	@echo '>> 🚀 Running example/namefully.dart...'
	@dart example/namefully.dart
	@echo '>> 🎉 Done!'

test: 		## Runs unit tests.
	@echo '>> 🧪 Running unit tests...'
	@dart test

report: 	## Reports on test coverage.
	@echo '>> 🔖 Collecting coverage on port 8888...'
	@dart --disable-service-auth-codes \
    	--enable-vm-service=8888 \
    	--pause-isolates-on-exit \
    	test/test_all.dart &
	@echo '>> 📖 Generate LCOV report...'
	@dart pub global run coverage:collect_coverage \
    	--port=8888 \
    	--out=coverage/coverage.json \
    	--wait-paused \
    	--resume-isolates
	@dart pub global run coverage:format_coverage \
    	--lcov \
    	--in=coverage/coverage.json \
    	--out=coverage/lcov.info \
    	--packages=.dart_tool/package_config.json \
    	--report-on=lib \
    	--check-ignore
	@genhtml coverage/lcov.info \
		--output-directory coverage/html \
		--show-details || (echo '▓▓ No html content generated ▓▓'; exit 1)

docs: 		## Generates API documentation.
	@echo '>> 📖 Generating API docs...'
	@dartdoc || (echo '▓▓ No docs content generated ▓▓'; exit 1)

prepublish: format test report
	@dart pub publish -n || (echo '▓▓ Package NOT ready to be published ▓▓'; exit 1)
	@echo '>> 🎉 Package ready to be published!'