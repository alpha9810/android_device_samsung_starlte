/*
 * SPDX-FileCopyrightText: 2026 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */
/*
 * Restore normal -> 60 fps mode after stream reconfiguration.
 * Keep the original function's frame, FPS adjustment, logs and return.
 *
 * Entry: r4=this, r7/r6=cached FPS, r5/r10=requested FPS.
 * Treat a reset normal mode as the existing 30 -> 60 fps transition.
 * Only the local comparison changes; the cached FPS stays intact
 * until store_fps, and vendor mode exceptions still apply.
 */
.syntax unified
.arch armv7-a
.thumb
.text
.global patch_start
.type patch_start, %function
.thumb_func
patch_start:
    cmp.w r10, #60
    bne cached_fps
    mov r0, r4
    bl get_config_mode
    cmp r0, #0
    it eq
    moveq r6, #30
cached_fps:
    cmp r7, r5
    it eq
    cmpeq r6, r10
    beq.w original_exit
    mov r0, r4
    movs r1, #18
    bl get_mode_value
    cmp r0, #20
    beq.w update_fps
    mov r0, r4
    movs r1, #20
    bl get_mode_value
    cmp r0, #5
    beq.w update_fps
    cmp r6, #30
    bhi check_normal
    cmp.w r10, #60
    bne check_normal
    movs r2, #1
    b apply_mode
check_normal:
    cmp r6, #60
    bne.w update_fps
    cmp.w r10, #30
    bhi.w update_fps
    movs r2, #0
apply_mode:
    mov r0, r4
    movs r1, #8
    bl set_mode_value
    mov r0, r4
    movs r1, #1
    bl set_restart_stream
    b.w update_fps
update_fps:
    cmp r7, r5
    bne store_fps
    ldr.w r0, [r4, #780]
    cmp r0, r10
    beq.w original_exit
store_fps:
    mov r0, r4
    mov r1, r5
    mov r2, r10
    bl set_preview_fps
    add.w r6, r4, #8
    b.w original_limit_log
    .fill (154 - (. - patch_start)) / 2, 2, 0xbf00
.size patch_start, . - patch_start
