class_name PlayDev
extends RefCounted
## DEV registration of the play feature: the bot, the screen commands, the run state, the invariants, the content state
## and the telemetry marks. The lambdas hold the one `PlayBot` of this boot until QACore releases them.


static func register() -> void:
	var bot: PlayBot = PlayBot.new()
	QACore.register_command("play.bot_next_input", "Returns the next input of the bot player: play, drop, resume, play again.",
		PackedStringArray(), func(args: PackedStringArray) -> RunCommandResult: return bot.next_input(args))
	QACore.register_command("play.open_play", "Opens the play scene with a new run; ends when the run takes drops.",
		PackedStringArray(), func(args: PackedStringArray) -> RunCommandResult: return await bot.open_play(args))
	QACore.register_command("play.open_pause", "Opens the pause popup over a new run.", PackedStringArray(),
		func(args: PackedStringArray) -> RunCommandResult: return await bot.open_pause(args))
	QACore.register_command("play.open_result", "Opens the result panel of a new run ended at once.", PackedStringArray(),
		func(args: PackedStringArray) -> RunCommandResult: return await bot.open_result(args))
	QACore.register_command("play.end_run", "Ends the run on screen as End run does; ends when the result panel opens.",
		PackedStringArray(), func(args: PackedStringArray) -> RunCommandResult: return await bot.end_run(args))
	QACore.register_command("play.state",
		"Reads the run on screen: phase, sliding block offset and width, top width, tolerance, speed, score, blocks, streaks.",
		PackedStringArray(), func(args: PackedStringArray) -> RunCommandResult: return bot.state(args))
	QACore.register_invariant("play.tower_in_range", func() -> bool: return bot.tower_in_range())
	QACore.register_invariant("play.record_in_range", func() -> bool: return PlayDev.record_in_range())
	QACore.set_content_state(func() -> String: return PlayDev.content_state(bot))
	EventCore.subscribe(PlayMomentEvent, bot.on_moment)


## The stored record, and the run on screen under `play` while one is on screen.
static func content_state(bot: PlayBot) -> String:
	var record: String = JSON.stringify({
		"runs": CommonRecord.runs(),
		"best_score": CommonRecord.best_score(),
		"best_streak": CommonRecord.best_streak(),
	})
	var run: String = bot.state_of_run()
	return "{\"record\":%s%s}" % [record, "" if run.is_empty() else ",\"play\":" + run]


static func record_in_range() -> bool:
	return CommonRecord.runs() >= 0 and CommonRecord.best_score() >= 0 and CommonRecord.best_streak() >= 0
