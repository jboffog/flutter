help:
	@echo 'Available commands:'
	@echo ''
	@echo 'format ............................... Formats dart files to line length 120'
	@echo 'generate_mobx_files ..................... Generate stores files (mobx)'
	@echo 'generate_hive_files ..................... Generate hive files (sharedPreferences)'
	@echo ''

format:
	flutter format . --line-length 120

generate_mobx_files:
	flutter pub run build_runner build --delete-conflicting-outputs && make format

generate_hive_files:
	flutter packages pub run build_runner build --delete-conflicting-outputs && make format	
