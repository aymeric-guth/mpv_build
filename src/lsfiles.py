from typing import Callable, List, Set, Any
from os import DirEntry, scandir, lstat
from os.path import splitext, getsize
from pathlib import Path
from functools import wraps, partial
from datetime import datetime


def handle_os_exceptions(
    fnc: Callable[[Any], Any]
) -> Callable[[Any], Any]:
    @wraps(fnc)
    def inner(*args, **kwargs) -> Any:
        try:
            return fnc(*args, **kwargs)
        except (PermissionError, OSError) as err:
            print(f"{fnc.__name__} called *args: {args} **kwargs: {kwargs}\nexception occured: {err}")
            return

    return inner


def lsfiles(
    fnc: Callable[[List[Any], DirEntry], None]
) -> Callable[[str], List[Any]]:
    files_list: List[Any] = []

    @handle_os_exceptions
    @wraps(fnc)
    def _lsfiles(path: Path) -> List[Any]:
        nonlocal fnc
        nonlocal files_list
        
        with scandir(path) as dir_content:
            for i in dir_content:
                if i.is_dir(follow_symlinks=False): 
                    _lsfiles(Path(i.path))
                else:
                    fnc(files_list, i)

        return files_list

    return _lsfiles


def filter_extensions(
    extensions: Set[str]
) -> Callable[[List[Any], DirEntry], None]:
    def inner(
        files_list: List[Any], 
        i: DirEntry
    ) -> None:
        """
        filter function according to extensions
        returns inode, path, filename, ext
        """
        nonlocal extensions
        
        file_name, extension = splitext(i.name)
        extension = extension.lower()
        if extension in extensions:
            offset = len(i.path) - len(i.name)
            path = i.path[:offset]
            # res = (
            #     i.inode(), 
            #     (path, file_name, extension)
            # )
            res = (
                path, 
                file_name, 
                extension
            )
            files_list.append(res)

    return inner


def filter_none(
    files_list: List[Any], 
    i: DirEntry
) -> None:
    file_name, extension = splitext(i.name)
    extension = extension.lower()
    offset = len(i.path) - len(i.name)
    path = i.path[:offset]
    res = (
        i.inode(), 
        (path, file_name, extension)
    )
    files_list.append(res)


def filter_meta(
    files_list: List[Any], 
    i: DirEntry
) -> None:
    file_name, extension = splitext(i.name)
    offset = len(i.path) - len(i.name)
    path = i.path[:offset]
    fstat_ = lstat(i)
    res = (
        path, 
        file_name, 
        extension, 
        getsize(i),
        fstat_.st_ino,
        datetime.fromtimestamp(fstat_.st_atime),
        datetime.fromtimestamp(fstat_.st_mtime),
        datetime.fromtimestamp(fstat_.st_ctime)
    )
    files_list.append(res)


def f(files_list: List[Any], i: DirEntry):
    ext = i.name.split('.')[-1]
    # print(i.name, ext)
    if ext == 'a':
        files_list.append(i.path)
