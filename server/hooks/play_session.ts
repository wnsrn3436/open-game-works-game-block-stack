import type { ApplyHook, PlaySessionRecord, PrepareHook, VerifyHook } from '../core/play-session/index.ts';
import type { RequestCtx, StorageContent } from '../core/storage/index.ts';
import * as GameContract from '../generated/contract/game_contract.ts';

/** The integer helpers of `validation` the hooks use. */
export interface IntegerOps {
  floor_div(a: bigint, b: bigint): bigint;
}

/** `prepare_play_session`: one run. `level_id` must be 0. A run has no loadout. */
export function prepare_run(): PrepareHook {
  return (_ctx: RequestCtx, _mode_id: number, level_id: number) => {
    if (level_id !== 0) return GameContract.GameError.GAME_ERROR_LEVEL_NOT_FOUND;
    return new Uint8Array(0);
  };
}

/**
 * `verify_play_session`: the result fits the run. A block comes at most once per `[next_block_delay]` of the play
 * session time; the score is at least 1 per block and at most the block points plus `[perfect_bonus_max]` per perfect;
 * the perfects are at most the blocks and the best streak at most the perfects. The run is not simulated again.
 */
export function verify_run(ops: IntegerOps): VerifyHook {
  return (ctx: RequestCtx, record: PlaySessionRecord, result: Uint8Array) => {
    const decoded = GameContract.PlaySessionResult.decode(result);
    if (decoded === null || record.level_id !== 0) return 'reject';
    return blocks_fit(ops, ctx, record, decoded) && score_fits(ctx, decoded) ? 'pass' : 'reject';
  };
}

/** The blocks fit the play session time: one block per `[next_block_delay]`, and one at the start. */
function blocks_fit(ops: IntegerOps, ctx: RequestCtx, record: PlaySessionRecord, decoded: GameContract.PlaySessionResult): boolean {
  const elapsed = record.finished_at - record.started_at;
  if (elapsed < 0n) return false;
  const limit = ops.floor_div(elapsed, ctx.data.GameSetting.next_block_delay()) + 1n;
  return BigInt(decoded.blocks) <= limit;
}

/** The score, the perfects and the best streak fit the blocks. */
function score_fits(ctx: RequestCtx, decoded: GameContract.PlaySessionResult): boolean {
  const bonus_max = BigInt(ctx.data.GameSetting.perfect_bonus_max());
  const blocks = BigInt(decoded.blocks);
  const score = BigInt(decoded.score);
  const perfects = BigInt(decoded.perfects);
  if (score < blocks || score - blocks > perfects * bonus_max) return false;
  return perfects <= blocks && BigInt(decoded.best_streak) <= perfects;
}

function record_of(storage: StorageContent, ctx: RequestCtx): GameContract.RecordUserState | null {
  return storage.get_state(ctx, GameContract.RecordUserState, 0n) as GameContract.RecordUserState | null;
}

/** `apply_play_session`: counts the run in `RecordUserState`. `FinishPlaySession` runs this once per play session. */
export function apply_run(storage: StorageContent): ApplyHook {
  return (ctx: RequestCtx, _record: PlaySessionRecord, result: Uint8Array) => {
    const decoded = GameContract.PlaySessionResult.decode(result);
    if (decoded === null) return GameContract.GameError.GAME_ERROR_UNSPECIFIED;
    storage.put_state(ctx, next_record(record_of(storage, ctx), decoded));
    return 'pass';
  };
}

/** The tower record with the finished run `decoded` counted. */
function next_record(stored: GameContract.RecordUserState | null, decoded: GameContract.PlaySessionResult): GameContract.RecordUserState {
  const next = new GameContract.RecordUserState();
  next.runs = (stored?.runs ?? 0) + 1;
  next.best_score = Math.max(stored?.best_score ?? 0, decoded.score);
  next.best_streak = Math.max(stored?.best_streak ?? 0, decoded.best_streak);
  next.total_blocks = (stored?.total_blocks ?? 0n) + BigInt(decoded.blocks);
  return next;
}
