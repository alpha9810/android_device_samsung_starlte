#!/usr/bin/env python3
#
# SPDX-FileCopyrightText: 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
"""Assemble both FPS fixes and verify the validated payload hashes."""

from hashlib import sha256
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory

ROOT = Path(__file__).resolve().parent
SPECS = {
    'arm': ('thumbv7-linux-android', 0xf0288,
            '8ba51aa45d0e3926b4494473177ec95f'
            'c55de495c96f28a689994691bf006ddf', {
        'get_config_mode': 0xf0139,
        'get_mode_value': 0x12b92b,
        'set_mode_value': 0x12b361,
        'set_restart_stream': 0xf007b,
        'set_preview_fps': 0xf0401,
        'original_limit_log': 0xf0323,
        'original_exit': 0xf0359,
    }),
    'arm64': ('aarch64-linux-android', 0x14f32c,
              '2c9d22efd717c38136bc995cdd478e4d'
              '2168d3d81fd162265e67e81052d9d50f', {
        'get_config_mode': 0x14f0e8,
        'get_mode_value': 0x1a5130,
        'set_mode_value': 0x1a4958,
        'set_restart_stream': 0x14ef70,
        'set_preview_fps': 0x14f550,
        'original_limit_log': 0x14f418,
        'original_exit': 0x14f460,
    }),
}


def main():
    with TemporaryDirectory(prefix='starlte-camera-fps-') as directory:
        for arch, (target, offset, expected, symbols) in SPECS.items():
            stem = 'restore_fps_mode_' + arch
            output = Path(directory) / stem
            subprocess.run([
                'clang', '--target=' + target, '-c',
                str(ROOT / (stem + '.S')),
                '-o', str(output.with_suffix('.o')),
            ], check=True)
            subprocess.run([
                'ld.lld', '--entry=patch_start', '--image-base=0',
                '--section-start=.text=' + hex(offset),
                '-o', str(output.with_suffix('.elf')),
                str(output.with_suffix('.o')),
                *['--defsym=' + k + '=' + hex(v)
                  for k, v in symbols.items()],
            ], check=True)
            subprocess.run([
                'llvm-objcopy', '--only-section=.text', '-O', 'binary',
                str(output.with_suffix('.elf')),
                str(output.with_suffix('.bin')),
            ], check=True)
            result = output.with_suffix('.bin').read_bytes()
            if sha256(result).hexdigest() != expected:
                raise RuntimeError(f'{arch}: FPS payload mismatch')
            print(f'{arch}: {len(result)} bytes match')


if __name__ == '__main__':
    main()
