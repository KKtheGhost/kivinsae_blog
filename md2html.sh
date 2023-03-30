#!/bin/bash

usage() {
    echo "Usage: md2html.sh --input <md_file> --output <html_file> --template <path_to_sample>"
    exit 1
}

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -i|--input)
    MD_FILE="$2"
    shift # past argument
    shift # past value
    ;;
    -o|--output)
    HTML_FILE="$2"
    shift # past argument
    shift # past value
    ;;
    -t|--template)
    TEMPLATE_FILE="$2"
    shift # past argument
    shift # past value
    ;;
    *) # unknown option
    usage
    ;;
esac
done

if [[ -z $MD_FILE || -z $HTML_FILE || -z $TEMPLATE_FILE ]]; then
    usage
fi

# Extract page title from markdown file
PAGE_TITLE=$(awk '/^title:/ {gsub(/[\"]/,"",$0); print $2; exit}' "$MD_FILE")

# Convert markdown to html
PAGE_CONTENT=$(pandoc -f markdown -t html "$MD_FILE")

# Replace placeholders in template file with page title and content
awk -v title="$PAGE_TITLE" -v content="$PAGE_CONTENT" '{gsub(/<!-- Page Title -->/,title);gsub(/<!-- Page Content -->/,content);print}' "$TEMPLATE_FILE" > "$HTML_FILE"
