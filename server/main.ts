import type { ApplyHook, PrepareHook, VerifyHook } from './core/play-session/index.ts';
import type { StorageContent } from './core/storage/index.ts';
import { apply_run, prepare_run, verify_run, type IntegerOps } from './hooks/play_session.ts';

/** The `core` object of `register`: the module objects this content uses. */
export interface RegisterCore {
  readonly routing: {
    register_hook(module: 'play-session', hook: 'prepare_play_session', fn: PrepareHook): void;
    register_hook(module: 'play-session', hook: 'verify_play_session', fn: VerifyHook): void;
    register_hook(module: 'play-session', hook: 'apply_play_session', fn: ApplyHook): void;
  };
  readonly storage: StorageContent;
  readonly validation: IntegerOps;
}

/**
 * Registers the hooks of a run. The game has no `service Game` `rpc`: a run starts with the core `StartPlaySession` and
 * ends with the core `FinishPlaySession`, whose hooks check the result and count it in the tower record.
 */
export function register(core: RegisterCore): void {
  core.routing.register_hook('play-session', 'prepare_play_session', prepare_run());
  core.routing.register_hook('play-session', 'verify_play_session', verify_run(core.validation));
  core.routing.register_hook('play-session', 'apply_play_session', apply_run(core.storage));
}
