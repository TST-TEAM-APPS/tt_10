firebase:
	flutterfire configure

splash: 
	flutter pub get
	dart run flutter_native_splash:create

icon: 
	flutter pub get
	dart pub run flutter_launcher_icons

runner: 
	flutter pub get
	dart run build_runner build

apk:
	flutter build apk

make update:
	git add .
	git commit -m "Update app"
	git push	