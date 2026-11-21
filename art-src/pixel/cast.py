"""The rest of the Drowned Rat cast, derived from Hale's body with new heads and palette remaps.

Each role keeps a distinct silhouette: the Choir thugs' hood and bone mask, the courier lying in
his red tabard, Bertha's ginger bun, apron and bottle.
"""
import hale

FRAMES = {}


def remap(rows, table):
    return ["".join(table.get(ch, ch) for ch in r) for r in rows]


BODY = hale.FRAMES["idle_s"][15:]

# Pale Choir thug: bone hood + mask with slit eyes and a red mark, plum coat, red sash, cosh.
THUG_HEAD = [
    "...........kkcccck..............",
    ".........kcCCCCccccK............",
    "........kcCCcccccccckK..........",
    ".......kcCcccccccccckkK.........",
    "......kcCccccccccccckkKK........",
    "......kcCcccccccccccckKK........",
    ".....kcCcKKKKKKKKKKKKckKK.......",
    ".....kcCKAAAAAAAAAAAAKkKK.......",
    ".....kcKAAAAAAAAAAAAAAKkK.......",
    ".....kcKAAeeeAAAAeeeAAKkK.......",
    ".....kKKAAAAAAqqAAAAAaKKK.......",
    "......kKAAAAAAqqAAAAaaKK........",
    "......KKKaAAAAqqAAAaaKK.........",
    ".......KKKaaaaaaaaaKKK..........",
    ".........KKKKKKKKKKK............",
]
THUG_BODY = remap(BODY, {"R": "T", "r": "t", "q": "P", "Q": "P", "B": "U", "b": "T", "v": "t",
                         "V": "P", "y": "r", "Y": "R", "M": "L", "m": "l",
                         "g": "n", "u": "n"})
FRAMES["thug_s"] = THUG_HEAD + THUG_BODY

# Bertha: ginger bun, cream kerchief, green dress, apron, a bottle in hand.
BERTHA_HEAD = [
    "..............3443..............",
    ".............344432.............",
    "...........AAAAAAAAA............",
    ".........AAAAAAAAAAAAa..........",
    "........34AAAAAAAAAAAaa2........",
    ".......3443333333333332221......",
    "......34433333332333322221......",
    "......3433322333233322221.......",
    "......332zzszzzsszzzz22221......",
    "......32zSSssssssssssz2221......",
    "......22SSSesssssssesz2211......",
    "......21SSSesssssssesz211.......",
    ".......1pSssssssssssspz1........",
    "........zzssssxxssssszz.........",
    ".........zzzzssssszzz...........",
]
BERTHA_BODY = remap(BODY, {"R": "i", "r": "f", "q": "F", "Q": "F", "B": "A", "b": "A", "v": "a",
                           "V": "a", "M": ".", "m": ".", "g": ".", "u": "f", "Y": "i", "y": "i",
                           "L": "I", "l": "i", "n": "f", "N": "F"})
FRAMES["bertha_s"] = BERTHA_HEAD + BERTHA_BODY

# The royal courier: Hale's build in a red-and-gold tabard with a satchel, pale and dying.
COURIER = remap(hale.FRAMES["idle_s"], {"b": "r", "B": "R", "v": "q", "V": "Q", "R": "g", "r": "g",
                                        "q": "G", "Q": "G", "s": "c", "S": "C", "z": "k", "Z": "K",
                                        "M": ".", "m": ".", "g": ".", "h": "j", "H": "h", "j": "J"})
FRAMES["courier_s"] = COURIER
