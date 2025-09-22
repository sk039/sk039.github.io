#!/bin/bash

ZOLA_BIN=${ZOLA_BIN:-$(which zola)}

$ZOLA_BIN build

if [ $? -eq 0 ] && [ -d public ]; then
	cd public

	git init 
	git add .
	git config user.email "sk.alvin.x@gmail.com"
	git config user.name "Alvin Scott"
	git commit -m "deploy blog"
	git push --force git@github.com:kscr-rust/kscr-rust.github.io master:gh-pages

	cd -
	rm public -rf
fi
