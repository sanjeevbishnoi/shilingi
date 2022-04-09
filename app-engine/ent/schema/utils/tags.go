package utils

import (
	"regexp"
	"strings"
)

var rmSpecialChars = regexp.MustCompile(`[^\w\s]`)
var extraSpaces = regexp.MustCompile(`\s+`)

// CleanTagName standardizes the tag name provided
// Removes special characters and lower cases the string
func CleanTagName(name string) string {
	name = rmSpecialChars.ReplaceAllLiteralString(name, "")
	name = extraSpaces.ReplaceAllLiteralString(name, " ")
	name = strings.ToLower(name)
	name = strings.TrimSpace(name)
	return name
}
