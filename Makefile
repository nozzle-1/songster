SHELL := /bin/bash

tests:
	flutter pub get
	flutter test

compile:
	echo "$(BASE64_FLUTTER_ENV)" | base64 -d > .env
	cat .env
	flutter pub get
	flutter build ios --release --no-codesign --dart-define-from-file=.env --build-name=$(VERSION)

fakesign:
	echo "TODO"

ipa:
	mkdir Payload
	mkdir Payload/Runner.app
	cp -R build/ios/iphoneos/Runner.app/ Payload/Runner.app/
	zip -r songster.ipa Payload
