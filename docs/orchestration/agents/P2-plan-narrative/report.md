# P2 report: narrative domains plan

(Saved by the orchestrator from the agent's hand-back.)

Plan: `docs/superpowers/plans/2026-11-21-narrative-domains.md`, 21 tasks, ~2,660 lines (mostly test code).
- W1: S0 fixtures wrapping P1 helpers. **Gate: needs P1 tasks 1, 2, 5, 6, 13, 14 merged and green.**
- W2: Q1, I1, D1, D3, C1, T1, T3, F1, E1, E2. W3: Q2, I2, D2, D4, C2, T2, F2. W4: Q3, D5, T4, F3.

Aligned to P1: reuses FakeFactProvider, ScriptedRandom, ContentFormatEffects, EventOutbox; `QuestLog.status()` uses `FactProvider.QUEST_*` (a quest closed by `closes_on` → failed, plus `is_abandoned()`); `FINALE_*` keys; CheckSpec validates via `CheckSkills.is_check_skill`.

API extensions (full list in the plan header): `with_*` setters on definitions; QuestLog(catalog), ClueBoard(clues, deductions), DialogueRunner(DialogueMemory); public `DialogueNodeFactory`; DialogueView `continue` pause; `DialogueDefinition.faction`; travel edges with a passability condition and forced hazards; TravelState `begin_journey`/`record_encounter`/pins; EncounterModifiers; stage 4 always uses the mountain table; RitualMeter bodyguards/aftermath/`seize_vault`/true-verse modifier; `FinaleSetup.configure`; FinaleChoices(meter); `EndingFacts.is_consistent()`; EndingRule wraps a Condition; EpilogueDefinition.

Contract notes for P3 (relayed by the orchestrator): pending_effects drains; the dialogue `continue` protocol; fill `DialogueDefinition.faction`; `record_encounter` after each roll; `Party.skill_bonus` into CheckTotals; event cards (§F.9) are owned by P3; the pathfinder "Wits 5" rule is an application policy.

Open design items: "Drowner encounters ×2 weight" at stage 2 does not fit a d8; `companion.forest_guide` (gdd §6.3) vs `ally.forest_guide` (§6.13) → ally used; `epilogue.*` is not an IdRules kind.
