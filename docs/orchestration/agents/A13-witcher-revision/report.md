# A13 report: witcher revision, D8 (saved by the orchestrator from the agent's hand-back)

**Files:** `docs/design/gdd.md` (§5 rewritten, new §6.19 Witcher stigma), `docs/design/content-format.md` (Addendum 2, §K), `docs/design/story-witcher.md` (new: the spine plus the 40-section work order), `docs/content/act1/01-drowned-rat.md` (full rewrite), `docs/content/_registry.md` (+24 ids, now 1,366).

## Protagonist
**Hale of the Matron**, an original witcher. The invented school is the Hollow Matron, on the Old Grey Matron peak; its craft is a gentler fraction of Ostrel's blood-sworn alchemy.
- **Look:** pale skin, amber slit-pupil eyes, black cropped hair, a notched ear, a crimson hooded mantle. The hood is a mechanic.
- **Swords:** steel `item.arming_sword`, and `item.silver_sword` (×1.6 against `monster` and `undead`).
- **Medallion:** `item.matron_medallion`, which senses `magic`.
- **Signs:** Knock, Ember and Hush, paid with stamina.
- **Elixirs:** Marrow, Gloam and Stoneblood; at most two active, each showing black veins.

## Stigma (gdd §6.19)
- **Infamy** runs 10–100 and starts at 30. Its tiers are tolerated, shunned, loathed and hunted. It never drops below 10.
- **NPC regard** for witchers: bigot, wary, pragmatic or kindred, separate from reputation.
- **stigma_mod:** Persuade −1 to −4, Intimidate +1 to +3. The hood softens it for strangers.
- **Prices:** ×1.25 to ×2.0, then refusal. Bribes are never marked up.
- **Per-zone heat:**
  - 25: muttering;
  - 50: a guard hassles him;
  - 75: stones;
  - 100: a mob.

  Signs add +25. Choir agitators feed heat; exposing one is −30.
- **Blames:** six Choir frames, total weight 75, each cleared only by proof.
- **Escalation:** each stage adds +5 infamy.

## §K additions
- **Calls:** `infamy()`, `stigma()`, `heat()`, `hooded()`, `seen_eyes()`, `blamed()`, `cleared()`, `regard()`, `sword_drawn()`, `elixir_active()`.
- **Ops:** `add_infamy`, `add_heat`, `set_heat`, `add_blame`, `clear_blame`, `show_eyes`, `set_hood`, `set_regard`, `raise_mob`, `heal_over_time`, `night_sight`, `buff`.
- **Triggers:** `heat`, `mob`, `medallion`.
- **Fields and blocks:** a zone `crowd` block; NPC `regard`, `hushable` and `magic`; option `vs` and `sign: hush`; shop `stigma`; a `silver` equip slot; the `blame` block and id kind.

## The slice
1. He starts hooded in the snug. His medallion trembles at a dead witcher's medallion nailed over the bar.
2. Bertha makes him look up and charges him double in the "witcher's cup". The drinkers move away.
3. The courier dies in his arms, and the room blames him (`blame.courier_murder`).
4. Bertha speaks up for him only if he paid her honestly.
5. Cobb turns the room against him. At heat 75 or more, regulars join the fight as `enemy.townsfolk`.
6. If he flees, Bertha bolts the hatch, and he passes the stake where Eel Row drowned the last witcher.
7. On the docks, Sergeant Brask, who knows him from Marnadal, sends the watch away: "Put your hood up."

## Bertha
**Bertha Kell**, 54, a pilot's widow. The Rat is named for her drowned husband. She calls everyone "love" except the witcher, and keeps a tally stick in her bun. In 1251 she hired Corrick of the Matron to recover her husband's body, then watched Eel Row drown Corrick and said nothing. She kept his medallion and cup. If she comes to trust Hale, she gives him the medallion (`item.corrick_medallion`).

## Calls and open issues
- **Calls the agent made:**
  - The Warden's Clause, a forgotten Pact article: "witchers pass every gate".
  - The Ash-Bound Zealot gets the `monster` tag.
  - Freeing an untrusting Aldric takes 3.0 s.
  - `item.arming_sword` and `item.gambeson` keep their ids.
- **Action items:**
  - Add the `blame` kind to architecture §8.2, `IdRules.KINDS` and the converter.
  - Stigma needs its own domain (`src/domain/stigma/`) and a save section before P4.
  - Update content-format's status line for Addendum 2.
  - Confirm that heat triggers fired by `add_heat` inside a dialogue resolve when the dialogue ends.
- **For art:** the player sprite needs two swords, the hood and amber eyes. Bertha's tally stick goes in her bun.

**IP check (orchestrator):** a grep for CDPR names and sign names is clean.
