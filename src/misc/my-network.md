# my network layout

my layout and structure of my various devices is probably a bit abnormal,
but i really enjoy how they work together. it wouldnt scale well at all
outside of the individual, but thats all i am and all i want from it so
it work well.

# overview

```
laptop - main computer i use
phone  - phone
nas    - raspberry pi 4 nas
server - old dell with decent size hdd
vps    - actual vps my domain ulthar.cat routes to

┌──────┐    ┌───┐    ┌─────┐
│laptop│◁──▷│nas│◁──▷│phone│
└──────┘    └───┘    └─────┘
   △          △         △
   └──────────┼─────────┘
              │
              ▽
          ┌──────┐
          │server│
          └──────┘
              │
              ▽
            ┌───┐
            │vps│
            └───┘
```

## explanation

i use syncthing to well, sync, most of my files between my devices, from
memes to bare git repos, to my full gemini root directory. this means i can be
quite lazy about things, and could modularize it if i chose to, though its not
much so like that currently, just no reason to. of course not everything syncs
to everything, for example theres no reason (or at least not one that warrants
the space) to have my git repositories on my phone, so i just dont sync it
there.

the only thing directly accessible from the outside world (or at least i hope)
is the server, which i then relay to my vps using frpc. no clue if thats the
ideal software to use, but it seemed good enough and ive been happy using it.

so in the end i can edit anything from anywhere if i chose to, and it would
update on every one of my devices, assuming i have internet at all. quite nice,
quite lazy, just how i like it.
