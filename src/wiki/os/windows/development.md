title: development on windows
css:   ../../../css/style.css

[%title]
========

programs and general setup that i use for development on windows

software
--------

- @[scoop](https://scoop.sh/):
  i use this for most things, and many of my scripts are hardcoded for the
  default installation path. unless otherwise noted, the following programs
  are installed using this.

- @[wsltty](https://github.com/mintty/wsltty):
  minimalish mintty wrapper around wsl, has some nice features but mostly 
  used for the convenient mintty.

- git: a given, no? especially helpful is submodules for as dependency
  management in projects is even more of a pain on windows, so embedding them
  inside of the project itself is the way to go (for my complexity at least)

- whatever language im using, see [languages](./languages.md) i use for windows.

scripts
-------

edit.bat
: wrapper script that runs program `edit` inside wsl `Alpine`. requires path 
  conversion inside wsl, so use a script to shim it.

```bat
%USERPROFILE%\scoop\apps\wsltty\current\bin\mintty.exe --WSL="Alpine" --configdir="%USERPROFILE%\scoop\apps\wsltty\current\config" sh -lic ^'edit %*^'
```

i use this as my ide basically, opening a separate cmd window if i need it.
(fun and quite useful windows trick: in file explorer, pressing Alt+d selects 
the path, and you can enter commands there!)
