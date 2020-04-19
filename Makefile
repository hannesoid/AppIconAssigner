install:
	swift build -c release
	cp -f .build/release/AppIconAssigner /usr/local/bin/AppIconAssigner
