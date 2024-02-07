build:
	swift build -c release

install: build
	install .build/release/package-manifest-generator /usr/local/bin/package-manifest-generator

clean:
	rm -rf .build

.PHONY: build install clean
