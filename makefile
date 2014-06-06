all: build/Overlay.js elm-runtime.js

build/Overlay.js: Overlay.elm
	elm Overlay.elm --only-js

elm-runtime.js:
	cp `(elm -g)` elm-runtime.js

clean:
	rm -rf build cache elm-runtime.js
