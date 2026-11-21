## Test helper: removes comments and string literal contents from GDScript lines so
## the architecture checker only sees code identifiers. Handles '...', "..." and
## triple-quoted strings (which may span lines), with backslash escapes.
class_name ArchSourceStripper
extends RefCounted

var _open_triple: String = ""


func strip(lines: PackedStringArray) -> Array[String]:
	_open_triple = ""
	var out: Array[String] = []
	for line: String in lines:
		out.append(_strip_line(line))
	return out


func _strip_line(line: String) -> String:
	var code := ""
	var i := 0
	if not _open_triple.is_empty():
		i = _skip_triple(line, 0)
	while i < line.length():
		var c := line[i]
		if c == "#":
			break
		if c == "\"" or c == "'":
			code += c + c
			i = _skip_string(line, i)
			continue
		code += c
		i += 1
	return code


## Returns the index after the string starting at `start`.
func _skip_string(line: String, start: int) -> int:
	var q := line[start]
	var triple := q.repeat(3)
	if line.substr(start, 3) == triple:
		_open_triple = triple
		return _skip_triple(line, start + 3)
	var i := start + 1
	while i < line.length():
		if line[i] == "\\":
			i += 2
			continue
		if line[i] == q:
			return i + 1
		i += 1
	return i


## Inside an open triple-quoted string: returns the index after its end, or the
## line length if it continues on the next line.
func _skip_triple(line: String, start: int) -> int:
	var end := line.find(_open_triple, start)
	if end < 0:
		return line.length()
	_open_triple = ""
	return end + 3
