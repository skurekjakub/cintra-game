## ConditionLexer: tokens of the content condition language (content-format.md §C grammar).
extends GutTest


func _tokens(text: String) -> Array[ConditionToken]:
	var r := ConditionLexer.tokenize(text)
	assert_true(r.is_ok(), "'%s' -> %s %s" % [text, r.error_code, r.detail])
	var toks: Array[ConditionToken] = r.value
	return toks


func _kinds(text: String) -> Array[StringName]:
	var out: Array[StringName] = []
	for t: ConditionToken in _tokens(text):
		out.append(t.kind)
	return out


func _texts(text: String) -> Array[String]:
	var out: Array[String] = []
	for t: ConditionToken in _tokens(text):
		out.append(t.text)
	return out


func test_call_compare() -> void:
	assert_eq(_kinds("skill(persuade) >= 4"),
		[&"word", &"lparen", &"word", &"rparen", &"op", &"int", &"end"] as Array[StringName])


func test_dotted_ids_and_commas() -> void:
	var toks := _tokens("count_ms(ms.a1_x,ms.b)")
	assert_eq(toks[2].text, "ms.a1_x")
	assert_eq(toks[3].kind, &"comma")


func test_negative_int() -> void:
	var toks := _tokens("rep(faction.crown) <= -10")
	assert_eq(toks[5].text, "-10")
	assert_eq(toks[5].kind, &"int")


func test_bad_characters_fail() -> void:
	assert_eq(ConditionLexer.tokenize("flag(flag.x) && true").error_code, &"condition_syntax")
	assert_eq(ConditionLexer.tokenize("act() = 2").error_code, &"condition_syntax")


func test_empty_and_blank_text_is_just_end() -> void:
	assert_eq(_kinds(""), [&"end"] as Array[StringName])
	assert_eq(_kinds(" \t\n "), [&"end"] as Array[StringName])


func test_end_token_sits_at_text_length() -> void:
	var toks := _tokens("act()")
	var last := toks[toks.size() - 1]
	assert_eq(last.kind, &"end")
	assert_eq(last.text, "")
	assert_eq(last.pos, 5)


func test_every_operator() -> void:
	assert_eq(_texts("== != <= >= < >"), ["==", "!=", "<=", ">=", "<", ">", ""] as Array[String])
	assert_eq(_kinds("== != <= >= < >"),
		[&"op", &"op", &"op", &"op", &"op", &"op", &"end"] as Array[StringName])


func test_operators_need_no_spaces() -> void:
	assert_eq(_texts("a>=1"), ["a", ">=", "1", ""] as Array[String])
	assert_eq(_texts("a<1"), ["a", "<", "1", ""] as Array[String])
	assert_eq(_texts("a!=-1"), ["a", "!=", "-1", ""] as Array[String])


func test_positions_are_character_offsets() -> void:
	var toks := _tokens("skill(x) >= 4")
	var positions: Array[int] = []
	for t: ConditionToken in toks:
		positions.append(t.pos)
	assert_eq(positions, [0, 5, 6, 7, 9, 12, 13] as Array[int])


func test_whitespace_is_skipped() -> void:
	assert_eq(_texts("  skill (\tpersuade\r\n) "), ["skill", "(", "persuade", ")", ""] as Array[String])


func test_keywords_are_plain_word_tokens() -> void:
	# The parser tells and/or/not/true/false apart by text, so they must stay words.
	var toks := _tokens("not flag(flag.a) and true or false")
	assert_eq(toks[0].kind, &"word")
	assert_eq(toks[0].text, "not")
	assert_eq(toks[5].kind, &"word")
	assert_eq(toks[5].text, "and")
	assert_eq(toks[6].text, "true")
	assert_eq(toks[7].text, "or")
	assert_eq(toks[8].text, "false")
	for i: int in range(toks.size() - 1):
		var is_punct := toks[i].kind == &"lparen" or toks[i].kind == &"rparen"
		assert_true(is_punct or toks[i].kind == &"word", "token %d is %s" % [i, toks[i].kind])


func test_word_charset_allows_digits_dots_and_underscores() -> void:
	assert_eq(_texts("a1_b2.c3"), ["a1_b2.c3", ""] as Array[String])
	assert_eq(_kinds("a1_b2.c3"), [&"word", &"end"] as Array[StringName])


func test_digit_start_is_an_int_not_a_word() -> void:
	assert_eq(_kinds("12"), [&"int", &"end"] as Array[StringName])
	assert_eq(_kinds("007"), [&"int", &"end"] as Array[StringName])
	# A digit run is an int; letters after it start a separate word, which the parser rejects.
	assert_eq(_kinds("4x"), [&"int", &"word", &"end"] as Array[StringName])


func test_minus_counts_only_before_a_digit() -> void:
	assert_eq(_texts("-0"), ["-0", ""] as Array[String])
	assert_eq(ConditionLexer.tokenize("-").error_code, &"condition_syntax")
	assert_eq(ConditionLexer.tokenize("- 5").error_code, &"condition_syntax")
	assert_eq(ConditionLexer.tokenize("a - 1").error_code, &"condition_syntax")


func test_double_minus_fails_at_the_first_minus() -> void:
	var r := ConditionLexer.tokenize("--5")
	assert_eq(r.error_code, &"condition_syntax")
	assert_eq(r.detail, "pos 0: '-'")


func test_error_detail_names_position_and_char() -> void:
	var r := ConditionLexer.tokenize("flag(flag.x) && true")
	assert_eq(r.error_code, &"condition_syntax")
	assert_eq(r.detail, "pos 13: '&'")


func test_lone_equals_and_bang_fail() -> void:
	var eq := ConditionLexer.tokenize("act() = 2")
	assert_eq(eq.detail, "pos 6: '='")
	var bang := ConditionLexer.tokenize("!flag(flag.x)")
	assert_eq(bang.detail, "pos 0: '!'")
	var tail := ConditionLexer.tokenize("a ==")
	assert_true(tail.is_ok())
	var triple := ConditionLexer.tokenize("a === 1")
	assert_eq(triple.detail, "pos 4: '='")
	var bang_end := ConditionLexer.tokenize("a !")
	assert_eq(bang_end.detail, "pos 2: '!'")


func test_uppercase_and_other_characters_fail() -> void:
	for text: String in ["Skill(x)", "a + b", "a;b", "a[0]", "\"x\"", "a#b", "é"]:
		assert_eq(ConditionLexer.tokenize(text).error_code, &"condition_syntax", text)


func test_token_constructor_stores_fields() -> void:
	var t := ConditionToken.new(&"op", ">=", 7)
	assert_eq(t.kind, &"op")
	assert_eq(t.text, ">=")
	assert_eq(t.pos, 7)
