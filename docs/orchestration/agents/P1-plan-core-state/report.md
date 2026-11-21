# P1 report: core rules and state plan

(Saved by the orchestrator from the agent's hand-back.)

Plan: `docs/superpowers/plans/2026-11-21-core-state-domains.md`, 21 tasks in 4 waves.
- W1: kernel additions (FactsChanged, EventOutbox, ScriptedRandom); rules ports (FactProvider, RepTiers, CheckSkills, FakeFactProvider); ArgSpec.
- W2: condition lexer, condition AST, EffectSignatures + EffectSpec, WorldState, Attributes/ActorSheet, factions, LevelTable/ExperienceTrack, Wallet, QueenCondition.
- W3: ConditionParser, EffectParser, CheckTotals, SkillTree, items + Inventory.
- W4: Equipment/QuickSlots, Shop, EscalationTrack, RumorPool.

Attribute checks: `CheckSkills.is_check_skill` accepts the 4 dialogue skills and the 5 attributes. Effect ops: `EffectSignatures` is a registry; Task 14 proves a new op = one signature registration; the plan has a "How to add an effect op" note.

API extensions (15 in the plan header), chiefly: EventOutbox; FactProvider gains visited/rumor_heard/queen_condition plus constants; RepTiers, CheckSkills, ArgSpec; `EffectParser.new(signatures)`; WorldState var bounds; RumorPool mark_heard/evaluate_verifications/heard_from with `verified_by`; inventory payload classes, `Inventory.room_for`, `Equipment.armor_total`, `Shop._init(stock, inventory, wallet)`.

Risks: P3 must register handler signatures into the shared EffectSignatures; P2 must use the quest status values; shared test helpers owned by P1 (P2 and P3 told by the orchestrator); `ExperienceTrack` returns earned points only and ActorSheet owns spent; about 11 content ops are outside §C/§E (format addendum pending); the stage 3 escalation condition references the Act II gate (P3 told to evaluate full conditions); Varn −10 "unless blackmailed" needs a conditional effect; speaker-specific check modifiers and unequip-before-sell belong to the application layer (P3 told); test snippets were not run, so expect small typing fixes.
