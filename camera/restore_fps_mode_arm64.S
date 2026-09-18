/*
 * SPDX-FileCopyrightText: 2026 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */
/*
 * Restore normal -> 60 fps mode after stream reconfiguration.
 * Keep the original function's frame, FPS adjustment, logs and return.
 *
 * Entry: x19=this, w25/w24=cached FPS, w21/w20=requested FPS.
 * Treat a reset normal mode as the existing 30 -> 60 fps transition.
 * Only the local comparison changes; the cached FPS stays intact
 * until store_fps, and vendor mode exceptions still apply.
 */
.text
.global patch_start
.type patch_start, %function
patch_start:
    cmp w20, #60
    b.ne cached_fps
    mov x0, x19
    bl get_config_mode
    cmp w0, #0
    mov w8, #30
    csel w24, w8, w24, eq
cached_fps:
    cmp w25, w21
    b.ne check_modes
    cmp w24, w20
    b.eq original_exit
check_modes:
    mov w1, #18
    mov x0, x19
    bl get_mode_value
    cmp w0, #20
    b.eq update_fps
    mov w1, #20
    mov x0, x19
    bl get_mode_value
    cmp w0, #5
    b.eq update_fps
    cmp w24, #30
    b.hi check_normal
    cmp w20, #60
    b.ne check_normal
    mov w2, #1
    b apply_mode
check_normal:
    cmp w24, #60
    b.ne update_fps
    cmp w20, #30
    b.hi update_fps
    mov w2, #0
apply_mode:
    mov x0, x19
    mov w1, #8
    bl set_mode_value
    mov x0, x19
    mov w1, #1
    bl set_restart_stream
    b update_fps
update_fps:
    cmp w25, w21
    b.ne store_fps
    ldr w8, [x19, #0x364]
    cmp w8, w20
    b.eq original_exit
store_fps:
    mov x0, x19
    mov w1, w21
    mov w2, w20
    bl set_preview_fps
    add x22, x19, #12
    b original_limit_log
    .fill (236 - (. - patch_start)) / 4, 4, 0xd503201f
.size patch_start, . - patch_start
