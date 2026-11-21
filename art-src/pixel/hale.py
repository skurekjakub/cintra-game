"""Hale, the hired sword (player). Frames are interior-only maps; pixelart.py adds the outline.

Read: crimson mantle-cloak (the one saturated accent), steel-blue coat, brown leather, sword hilt
over the right shoulder. Light from the top-left.
"""

FRAMES = {}

FRAMES["idle_s_v1"] = [
    "..............H.HH..............",
    "...........HHHhHhhHhh...........",
    ".........HHHhhhhhhhhhhj.........",
    "........HHhhHhhhhhhhhhhjj.......",
    ".......HHhhHhhhhhhhhhhhhjj......",
    ".......HhhhhhjhhhhjhhhhhjjJ.....",
    "......Hhhhhjzjhhhjzjhhhjhjj.....",
    "......hhhjzSszjjzsszjjhzzjjJ....",
    "......hhjzSSsssssssssssszjjJ....",
    "......hjjSSessssssssesszzjJ.....",
    "......jjzSSessssssssesszzJJ.....",
    ".......jzpSsssssssssspzzJ.......",
    "........zzsssssxxsssszzz........",
    ".........zzzssssssszzz..........",
    "........RqqqzzzzzzzzqqqQ........",
    ".......RRrrqqbbbbbbqqqrqQ.......",
    "......RRrrrqBBbbbbbbbvqrrqQ.....",
    "......RrrrqBBbbbbbbbbbvqrqQ.....",
    ".....RrrrqBBbbbbbbbbbbbvqqQQ....",
    ".....RrrqBBbVbbbbybbbbVvvqQQ....",
    ".....RrrqBbbVbbbbbbbbbVvvqQQ....",
    ".....RrqqBbbVbbbbybbbbVvvqQQ....",
    ".....RrqSSsbVbbbbbbbbbVzzZqQ....",
    ".....RrqssNLlllllyYllllnNzqQ....",
    ".....RrqzzVbbbbbbbbbbbbVZzqQ....",
    "......rqqQVbbbbbvVbbbbbVQqQQ....",
    "......qqQQvbbbbvVVvbbbbvVQQQ....",
    ".......QQ.nllllnN.Nnllllnn......",
    "..........nLlllnN.NLllllnn......",
    "..........NLllnnN.NLllnnN.......",
    "..........NLlnnNN.NLlnnNN.......",
    ".........NNNNNNN...NNNNNNN......",
]

# v2: spiky clumped hair with a top-left highlight band, sleeves separated from the coat,
# sword held point-down in the right hand (strong silhouette), belt pouch, darker coat flank.
FRAMES["idle_s_v2"] = [
    "...........H...HH...h...........",
    "..........HHh.HHhh.hhj..........",
    "........HHHHhhHHhhhhhjj.j.......",
    ".......HHHHhhhHhhhhhjhhjj.......",
    "......HHHhhhHHhhhjhhhhjhjj......",
    "......HHhhjhhhhhjjhhhjjhjjJ.....",
    ".....HHhhjjhhhjjhhhhjjhhjjJ.....",
    ".....HhhjjhjhhjhhjhhjhjjjjJ.....",
    ".....hhjjzjzsjjzsszjjzzjjjJ.....",
    "......hjzSSssssssssssszjjJJ.....",
    "......jjSSSesssssssesszzJJ......",
    "......jzSSSesssssssesszzJ.......",
    ".......zpSssssssssssspzz........",
    "........zzssssxxssssszz.........",
    ".........zzzzssssszzz...........",
    "........RqqqzzzzzzzzqqQ.........",
    ".......RRrqqbBBbbbbbvqqrQ.......",
    "......RRrBBqbBBbbbbbvqvvrQ......",
    "......RrBBBvqBbbbbbbvqvvvqQ.....",
    ".....RRrBBvvqBbbybbbvqVvvvqQ....",
    ".....RrrBBvvqbbbbbbbvqVvvvqQ....",
    ".....RrrBbvvqbbbybbbvqVvVvqQ....",
    ".....RrrBbvvqbbbbbbbvqVvVvqQ....",
    "....YRrrSSsznLLlyYllnNzzZqQQ....",
    "....yuRrSssznbbbbbbbvnzZZqQQ....",
    "....MgRrqzzQVbbbbbbvvVQQqqQ.....",
    "....MgrqqQ.VbbbbvVbbbvVQqQQ.....",
    "....Mg.qQ..vnllllnNnlllnnQ......",
    "...Mg......nLllllnNnLllnn.......",
    "...Mg......NLllnnN.NLllnN.......",
    "...g.......NLlnnNN.NLlnnN.......",
    "..........NNNNNNN..NNNNNN.......",
]


def _edit(base, edits, clear=()):
    """Copy a frame and apply (x, y, chars) edits; `clear` lists (x0, x1, y) spans to erase."""
    g = [list(r.ljust(32, ".")) for r in base]
    for x0, x1, y in clear:
        for x in range(x0, x1 + 1):
            g[y][x] = "."
    for x, y, s in edits:
        for i, ch in enumerate(s):
            g[y][x + i] = ch
    return ["".join(r) for r in g]


# v3: smaller face highlight, dark-blue (not red) sleeve seams, a proper sword in the hand:
# pommel above the fist, gold guard, a 2-px blade down the left side.
FRAMES["idle_s_v3"] = _edit(FRAMES["idle_s_v2"], [
    (9, 9, "s"), (8, 10, "jjS"), (8, 11, "jzS"),
    (12, 17, "V"), (12, 18, "V"), (12, 19, "V"), (12, 20, "V"), (12, 21, "V"), (12, 22, "V"),
    (21, 17, "V"), (21, 18, "V"), (21, 19, "V"), (21, 20, "V"), (21, 21, "V"), (21, 22, "V"),
    (8, 22, "BY"),
    (5, 23, "RrSSsz"),
    (5, 24, "uyYyuz"),
    (5, 25, "RqmMg"), (5, 26, "qqmMg"), (6, 27, "qmMg"), (7, 28, "mMg"), (7, 29, "mMg"), (7, 30, "mMg"), (8, 31, "mg"),
], clear=[(3, 6, 25), (3, 6, 26), (3, 6, 27), (3, 6, 28), (3, 6, 29), (3, 6, 30), (3, 4, 23), (3, 4, 24)])

# v4: richer, darker hair mass with clumps on the shadow side; highlight strands stay top-left.
FRAMES["idle_s"] = _edit(FRAMES["idle_s_v3"], [
    (17, 3, "jh"), (19, 4, "jj"), (16, 5, "jjh"), (21, 6, "jjhjjJ"), (18, 7, "jhjjj"),
    (9, 4, "H"), (8, 5, "H"),
])
