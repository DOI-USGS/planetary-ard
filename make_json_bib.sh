# Use citation-js to convert the bibtext bibliography into a JSON-CSL bibliography.
# citation-js is a npm package
node_modules/citation-js/bin/cmd.js -i resources/ardbib.bib > content/bibliography.json
