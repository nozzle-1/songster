SHELL := /bin/bash

tests:
	flutter pub get
	flutter test

compile-ios:
	echo "$(BASE64_FLUTTER_ENV)" | base64 -d > .env
	flutter pub get
	flutter build ios --release --no-codesign --dart-define-from-file=.env --build-name=$(VERSION)
	make convert-ipa

convert-ipa:
	mkdir Payload
	mkdir Payload/Runner.app
	cp -R build/ios/iphoneos/Runner.app/ Payload/Runner.app/
	zip -r songster.ipa Payload

compile-android:
	echo "$(BASE64_FLUTTER_ENV)" | base64 -d > .env
	flutter build apk --release --dart-define-from-file=.env --build-name=$(VERSION)
	mv build/app/outputs/flutter-apk/app-release.apk songster.apk
