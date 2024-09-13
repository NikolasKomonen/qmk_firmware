# Quantum Mechanical Keyboard Firmware

## Branch

This branch is a diff on top of the upstream qmk branch.

Keep the `master` branch in sync with the upstream and then rebase `diff` ontop of it.

## Keebio - Iris CE update steps

1. Go to [config.qmk.fm](https://config.qmk.fm/)
1. Fill in the fields
    - `Keyboard`: `keebio/iris_ce/rev1`
    - `Keymap Name`: `qwerty_homerow_mod`
1. Upload the JSON: `./keyboards/keebio/iris_ce/keymaps/qwertyIris/qwerty_homerow_mod.json`
1. Make your edits
1. Download the JSON to the same location you uploaded it from (overwrite the old file)
1. Use the script `./compileIris` which does the steps in the Manual Commands down below

### Manual Commands

1. Compile the JSON to C
    - `qmk json2c keyboards/keebio/iris_ce/keymaps/qwertyIris/qwerty_homerow_mod.json -o keyboards/keebio/iris_ce/keymaps/qwertyIris/keymap.c`
1. Copy the content of `keymapAchordion` into the end of `keymap.c` in the folder `./keyboards/keebio/iris_ce/keymaps/qwertyIris`
1. Build the final firmware
  - `qmk compile -kb keebio/iris_ce/rev1 -km qwertyIris`
