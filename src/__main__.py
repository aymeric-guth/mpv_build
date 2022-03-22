import os
import shutil
from pathlib import Path

from .lsfiles import lsfiles


if __name__ == '__main__':
    def f(files_list, i):
        ext = i.name.split('.')[-1]
        if i.is_file() and ext == 'a':
            files_list.append(i.path)

    try:
        [ os.remove(f) for f in lsfiles(f)(os.getenv('TEMP')) ]
    except Exception as err:
        print(f'Exception occured: {err}')
