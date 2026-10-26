class_name CommonRecord
extends RefCounted
## Reads the tower record of the user (`RecordUserState`). Every value is 0 before the first finished run.


static func runs() -> int:
	var record: GameContract.RecordUserState = _record()
	return 0 if record == null else record.runs


static func best_score() -> int:
	var record: GameContract.RecordUserState = _record()
	return 0 if record == null else record.best_score


static func best_streak() -> int:
	var record: GameContract.RecordUserState = _record()
	return 0 if record == null else record.best_streak


static func _record() -> GameContract.RecordUserState:
	return UserStateCore.get_single(GameContract.RecordUserState) as GameContract.RecordUserState
