SHELL := /bin/bash

tests:
	flutter pub get
	flutter test

compile:
	flutter pub get
	flutter build ios --release --no-codesign

fakesign:
	echo "TODO"

ipa:
	mkdir Payload
	mkdir Payload/Runner.app
	cp -R build/ios/iphoneos/Runner.app/ Payload/Runner.app/
	zip -r songster.ipa Payload
