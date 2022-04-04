all: clean html5

clean:
	rm -rf build/*

_md_html5:
	mkdir -p build/html5

html5: _md_html5
	godot --no-window --path ./project.godot --export HTML5 build/html5/index.html \
	&& cd build/html5 \
	&& rm -f **/*.import \
	&& 7zz a -mx=9 html5.7z * 
