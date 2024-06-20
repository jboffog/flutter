help:
	@echo 'Available commands:'
	@echo ''
	@echo 'generate_dev_apk ..................... Generate apk using flavor dev'
	@echo 'generate_splash_screen ..................... Generate assets to splash screen'
	@echo 'generate_app_icons ..................... Generate assets to app icons'

generate_dev_apk:
	flutter build apk --profile --no-tree-shake-icons

generate_splash_screen:
	dart run flutter_native_splash:create

generate_app_icons:
	flutter pub run flutter_launcher_icons
