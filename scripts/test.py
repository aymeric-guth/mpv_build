#!/usr/bin/env python3
import os
import sys
import subprocess
import pathlib
import os.path


project_path = pathlib.Path(__file__).parent.parent
test_files = project_path / "testfiles"

if len(sys.argv) > 2:
    raise SystemExit("Too many arguments")

test_set = {
    'openmpt': {
        ".669",
        ".amf",
        ".ams",
        ".c67",
        ".dbm",
        ".digi",
        ".dmf",
        ".dsm",
        ".dsym",
        ".dtm",
        ".far",
        ".fmt",
        ".gdm",
        ".ice",
        ".st26",
        ".imf",
        ".itp",
        ".j2b",
        ".m15",
        ".stk",
        ".mdl",
        ".med",
        ".mo3",
        ".mt2",
        ".mtm",
        ".mus",
        ".okt",
        ".oxm",
        ".psm",
        ".plm",
        ".pt36",
        ".ptm",
        ".sfx",
        ".sfx2",
        ".mms",
        ".stm",
        ".stx",
        ".stp",
        ".symmod",
        ".ult",
        ".umx",
        ".wow",
        ".mod",
        ".s3m",
        ".xm",
        ".mptm",
        ".mid",
    },
    'opus': {
        ".opus",
        ".ogg"
    },
    'gme': {
        "ay",
        "bgs",
        "gym",
        "hes",
        "kss",
        "nsf",
        "nsfe",
        "sap",
        "spc",
        "vgm",
        "vgz"
    },
    'all': {},
    'fdk': {
        '.aac',
        '.m4a',
        '.alac'
    },
    'std': {
        '.wav',
        '.aiff',
        '.flac',
        '.aif',
        '.ape',
        '.wv',
        '.mp3',

    },
}

if len(sys.argv) == 1 or sys.argv[1] == 'all' or sys.argv[1] not in test_set:
    exts = set()
    [exts.update(test_set[i]) for i in test_set]
else:
    exts = test_set.get(sys.argv[1])

files = [
    i for i in os.listdir(test_files) 
    if i[0] != "." 
    and (lambda x: os.path.splitext(x)[-1])(i) in exts
]
print(f'{files=}')
print(f'{exts=}')
if not files:
    raise SystemExit("No test files found")

mpv = project_path / "x86_64-apple-darwin18/bin"
termx, _ = os.get_terminal_size()


for f in files:
    template = \
        '*' * termx + '\n' + \
        '*' + ' ' * (termx-2) + '*' + '\n' + \
        '* ' + (lambda s, x: s.ljust(x))(str(f), termx-4) + ' *' + '\n' + \
        '*' + ' ' * (termx-2) + '*' + '\n' + \
        '*' * termx + '\n'
    print(template)
    subprocess.run([
        mpv / "mpv",
        "--volume=50",
        "--no-video",
        str(test_files / f)
    ])
