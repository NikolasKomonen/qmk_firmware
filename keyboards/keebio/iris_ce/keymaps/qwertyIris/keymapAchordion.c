// Pasted from `./keymapAchordion.c`
// Code from here: https://getreuer.info/posts/keyboards/achordion/index.html#add-achordion-to-your-keymap

#include "features/achordion.h"

bool process_record_user(uint16_t keycode, keyrecord_t* record) {
  if (!process_achordion(keycode, record)) { return false; }
  // Your macros ...

  return true;
}

void matrix_scan_user(void) {
  achordion_task();
}
