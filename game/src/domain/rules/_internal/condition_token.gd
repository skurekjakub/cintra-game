## One lexical token of a content condition (content-format.md §C grammar).
## kind is one of &"lparen", &"rparen", &"comma", &"op", &"int", &"word" or &"end".
## Keywords (and/or/not/true/false) are plain &"word" tokens; the parser tells them apart by text.
## pos is the character offset of the token in the condition text.
class_name ConditionToken
extends RefCounted

var kind: StringName
var text: String
var pos: int


func _init(token_kind: StringName, token_text: String, token_pos: int) -> void:
	kind = token_kind
	text = token_text
	pos = token_pos
