import { randomUUID } from 'node:crypto';
import * as Testing from '../core/testing/dev/index.ts';
import * as CoreContract from '../generated/contract/core_contract.ts';
import * as GameContract from '../generated/contract/game_contract.ts';

const LOADED = Testing.load_data();
const DATA = LOADED.data;
const SETTING = DATA.GameSetting;
const MODE = LOADED.dev.find_id_value('[mode_tower]');
const DELAY = SETTING.next_block_delay();
const BONUS_MAX = SETTING.perfect_bonus_max();

function code(envelope: CoreContract.ResponseEnvelope): number {
  return envelope.error?.code ?? 0;
}

interface ResultInput {
  blocks: number;
  score: number;
  perfects?: number;
  best_streak?: number;
}

function result(input: ResultInput): Uint8Array {
  const out = new GameContract.PlaySessionResult();
  out.blocks = input.blocks;
  out.score = input.score;
  out.perfects = input.perfects ?? 0;
  out.best_streak = input.best_streak ?? 0;
  return out.encode();
}

function start(session: Testing.TestSession, level_id = 0): Promise<Testing.SendResult> {
  const request = new CoreContract.StartPlaySessionRequest();
  request.mode_id = MODE;
  request.level_id = level_id;
  return Testing.send(session, 'core/StartPlaySession', request);
}

function finish(session: Testing.TestSession, play_session_id: string, bytes: Uint8Array, request_id?: string): Promise<Testing.SendResult> {
  const request = new CoreContract.FinishPlaySessionRequest();
  request.play_session_id = play_session_id;
  request.result = bytes;
  return Testing.send(session, 'core/FinishPlaySession', request, request_id);
}

async function tower_record(server: Testing.TestServer, user_id: bigint): Promise<GameContract.RecordUserState | null> {
  const item = (await Testing.read_user_state(server, user_id)).find((entry) => entry.kind === 'RecordUserState');
  return item === undefined ? null : (item.value as GameContract.RecordUserState);
}

describe('tower play session', () => {
  let server: Testing.TestServer;
  let accounts = 0;

  beforeEach(async () => {
    server = await Testing.start_test_server();
  });

  afterEach(async () => {
    await Testing.stop_test_server(server);
  });

  async function player(): Promise<Testing.TestSession> {
    accounts += 1;
    return Testing.login(server, `tower_${String(accounts)}`);
  }

  /** Starts a run, lets `elapsed` pass on the server and finishes it with `bytes`. */
  async function played(session: Testing.TestSession, elapsed: bigint, bytes: Uint8Array, request_id?: string): Promise<Testing.SendResult> {
    const started = await start(session);
    expect(code(started.envelope)).toBe(0);
    Testing.advance_time(server, elapsed);
    return finish(session, (started.response as CoreContract.StartPlaySessionResponse).play_session_id, bytes, request_id);
  }

  it('starts a run of a new user with an empty loadout and no record', async () => {
    const session = await player();
    const sent = await start(session);
    expect(code(sent.envelope)).toBe(0);
    const response = sent.response as CoreContract.StartPlaySessionResponse;
    expect(response.play_session_id).not.toBe('');
    expect(response.loadout.length).toBe(0);
    expect(await tower_record(server, session.user_id)).toBeNull();
  });

  it('refuses a run with a level target and keeps no play session', async () => {
    const session = await player();
    const sent = await start(session, 3);
    expect(code(sent.envelope)).toBe(GameContract.GameError.GAME_ERROR_LEVEL_NOT_FOUND);
    const finished = await finish(session, randomUUID(), result({ blocks: 0, score: 0 }));
    expect(code(finished.envelope)).toBe(CoreContract.CoreError.CORE_ERROR_PLAY_SESSION_NOT_FOUND);
    expect(await tower_record(server, session.user_id)).toBeNull();
  });

  it('counts a finished run in the record and sends it in the delta', async () => {
    const session = await player();
    const sent = await played(session, 30000n, result({ blocks: 20, score: 29, perfects: 4, best_streak: 3 }));
    expect(code(sent.envelope)).toBe(0);
    const entry = sent.envelope.user_state?.entries.find((item) => item.kind === 'RecordUserState');
    expect(entry).toBeDefined();
    const record = await tower_record(server, session.user_id);
    expect(record?.runs).toBe(1);
    expect(record?.best_score).toBe(29);
    expect(record?.best_streak).toBe(3);
    expect(record?.total_blocks).toBe(20n);
    expect(sent.envelope.item_changes.length).toBe(0);
  });

  it('keeps the best score and streak and adds the blocks of later runs', async () => {
    const session = await player();
    expect(code((await played(session, 40000n, result({ blocks: 30, score: 41, perfects: 5, best_streak: 4 }))).envelope)).toBe(0);
    expect(code((await played(session, 10000n, result({ blocks: 8, score: 9, perfects: 1, best_streak: 1 }))).envelope)).toBe(0);
    const record = await tower_record(server, session.user_id);
    expect(record?.runs).toBe(2);
    expect(record?.best_score).toBe(41);
    expect(record?.best_streak).toBe(4);
    expect(record?.total_blocks).toBe(38n);
  });

  it('counts a run that ends at once with no block', async () => {
    const session = await player();
    expect(code((await played(session, 0n, result({ blocks: 0, score: 0 }))).envelope)).toBe(0);
    const record = await tower_record(server, session.user_id);
    expect(record?.runs).toBe(1);
    expect(record?.best_score).toBe(0);
  });

  it('accepts the largest score the bounds allow', async () => {
    const session = await player();
    const blocks = 10;
    const elapsed = DELAY * BigInt(blocks - 1);
    const sent = await played(session, elapsed, result({ blocks, score: blocks * (1 + BONUS_MAX), perfects: blocks, best_streak: blocks }));
    expect(code(sent.envelope)).toBe(0);
    expect((await tower_record(server, session.user_id))?.best_score).toBe(blocks * (1 + BONUS_MAX));
  });

  it('applies a resent finish once', async () => {
    const session = await player();
    const request_id = randomUUID();
    const started = await start(session);
    Testing.advance_time(server, 20000n);
    const id = (started.response as CoreContract.StartPlaySessionResponse).play_session_id;
    const bytes = result({ blocks: 12, score: 14, perfects: 1, best_streak: 1 });
    expect(code((await finish(session, id, bytes, request_id)).envelope)).toBe(0);
    expect(code((await finish(session, id, bytes, request_id)).envelope)).toBe(0);
    const record = await tower_record(server, session.user_id);
    expect(record?.runs).toBe(1);
    expect(record?.total_blocks).toBe(12n);
  });

  it('answers a second finish of a counted run with not found and counts it once', async () => {
    const session = await player();
    const started = await start(session);
    Testing.advance_time(server, 20000n);
    const id = (started.response as CoreContract.StartPlaySessionResponse).play_session_id;
    const bytes = result({ blocks: 12, score: 12 });
    expect(code((await finish(session, id, bytes)).envelope)).toBe(0);
    expect(code((await finish(session, id, bytes)).envelope)).toBe(CoreContract.CoreError.CORE_ERROR_PLAY_SESSION_NOT_FOUND);
    expect((await tower_record(server, session.user_id))?.runs).toBe(1);
  });

  const rejected: [string, bigint, ResultInput][] = [
    ['more blocks than the play session time allows', DELAY * 4n, { blocks: 6, score: 6 }],
    ['a score below one point per block', 30000n, { blocks: 20, score: 19 }],
    ['a score above the bonus of the perfects', 30000n, { blocks: 20, score: 20 + BONUS_MAX + 1, perfects: 1, best_streak: 1 }],
    ['more perfects than blocks', 30000n, { blocks: 5, score: 10, perfects: 6, best_streak: 1 }],
    ['a best streak longer than the perfects', 30000n, { blocks: 20, score: 23, perfects: 3, best_streak: 4 }],
  ];
  for (const [name, elapsed, input] of rejected) {
    it(`rejects ${name} and changes nothing`, async () => {
      const session = await player();
      const sent = await played(session, elapsed, result(input));
      expect(code(sent.envelope)).toBe(CoreContract.CoreError.CORE_ERROR_PLAY_SESSION_REJECTED);
      expect(await tower_record(server, session.user_id)).toBeNull();
    });
  }

  it('rejects a result over the PlaySessionResult bounds without a change', async () => {
    const session = await player();
    const sent = await played(session, 30000n, result({ blocks: 100001, score: 100001 }));
    expect(code(sent.envelope)).toBe(CoreContract.CoreError.CORE_ERROR_INVALID_REQUEST);
    expect(await tower_record(server, session.user_id)).toBeNull();
  });

  it('rejects the finish of a play session of another user', async () => {
    const owner = await player();
    const other = await player();
    const started = await start(owner);
    Testing.advance_time(server, 20000n);
    const id = (started.response as CoreContract.StartPlaySessionResponse).play_session_id;
    const sent = await finish(other, id, result({ blocks: 3, score: 3 }));
    expect(code(sent.envelope)).toBe(CoreContract.CoreError.CORE_ERROR_PLAY_SESSION_NOT_FOUND);
    expect(await tower_record(server, other.user_id)).toBeNull();
    expect(await tower_record(server, owner.user_id)).toBeNull();
  });
});
