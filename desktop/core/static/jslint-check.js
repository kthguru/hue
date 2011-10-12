/**
 * Performs command line jslint validation.
 */
load("repos/JSLint/jslint.js");

for (var argi = 0; argi < arguments.length; ++argi) {
	var filename = arguments[argi];
	var src = readFile(filename);

	print ("JSLint checking " + filename + ".\n");

	JSLINT(src, {
			evil: true, forin: true, maxerr: 1000, indent: 4
		});

	// All of the following are known issues that we think are 'ok'
	var ok = [
		"'e' is already defined.",
		"'jQuery' was used before it was defined.",
		"'dojo' was used before it was defined.",
		"'window' was used before it was defined.",
		"'cloudera' was used before it was defined.",
		"'console' was used before it was defined.",
		" was used before it was defined.",
		"Expected exactly one space between",
		"Expected '===' and instead saw '=='.",
		"Expected exactly one space between 'function' and '('.",
		"Unexpected dangling '_' in ",
		"Unexpected space between ",
		"Unexpected '++'",
		"Missing 'use strict' statement.",
		"Missing space between ')' and '{'.",
		"Missing space between",
		"Combine this with the previous 'var' statement.",
		", not column"
	];

	var okPredicates = function(str) {
		var result = false;
		for (var i = 0; i < ok.length; i += 1) {
			if (str.indexOf(ok[i]) !== -1) {
				result = true;
				break;
			}
		}
		return result;
	};

	var e = JSLINT.errors, found = 0, w;

	for ( var i = 0; i < e.length; i++ ) {
		w = e[i];

		if ( w && !okPredicates( w.reason ) ) {
			found++;
			print( "Line " + w.line + " char " + w.character + ": " + w.reason );
			print( "\n    " + w.evidence + "\n" );
		}
	}

	if ( found > 0 ) {
		print( "\n" + found + " error(s) found." );
	}
}
