## defects

| id | result | note |
|---|---|---|

The input has no defects.

## unverified

- Bot playtest, UI quality check, performance check and `ogw measure` were not run by the content agent (they run in `ogw loop evaluate`). A hand-driven run of the scenario on an instance (bot inputs through `ogw command`/`ogw input`, two runs to the result panel, `lobby.open_lobby`, `restart` with the same content state before and after) ended with no error log, no invariant failure and no softlock
- Layout on the 1440x900 (16:10) UI check screen: only the 1920x1080 window was looked at
- The final look: every image and sound is still a placeholder; the theme tints the near-white block and button art, so the colors of the screens are checked only once the final art is in
- Step mode play: whether a `key Space` put in between steps lands at the offset `ogw step --state` showed (`play-guide.md` `## play mode`, marked `unconfirmed`)
- The terms popup of a new user was not opened on an instance (dev accounts start without it); its prefab passes the static checks
- The bot drops late through the `ogw` CLI (about 300ms per call), so perfect drops (the `Reward` mark) were not seen on the instance; the tower simulation tests cover perfect drops, regrow and the streak bonus

## requests

- records/loops/create-1792989369596/resource-requests/1792990167257.md (`image/ui_kit`, `app_icon/main`, `splash/main`, `font/main`, `background/sky`, `sfx/place`, `sfx/perfect`, `sfx/fail`, `bgm/main`)
- Not requested yet: `nine_slice/block`, `nine_slice/ui/panel`, `nine_slice/ui/button`, `icon/best`, to be requested with `--see image/ui_kit` once `image/ui_kit` is final (see assumptions)
- core proposals: none

## assumptions

- records/loops/create-1792989369596/assumptions.md: UI art keys waiting for the UI kit; the slide, perfect and regrow numbers; the perfect streak bonus and regrow; the pause popup; bound-only result verification; `sfx/place` as the UI press sound; gamepad prompt names; the code-made toast
