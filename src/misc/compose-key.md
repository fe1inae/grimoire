# using the compose key

decided to setup a compose key for myself, not because i need to type
other languages, but just because i like being able to type unicode
hearts and smileys etc ☺♥⑨

for river, just tossing these into env before the compositor starts is
enough

```
# compose key
export XKB_DEFAULT_LAYOUT=us
export XKB_DEFAULT_OPTIONS=compose:ralt
```

to use: press the compose key, (alt in this case), then the key combination

heres a cheatsheet for myself of combinations i want to remember
(probalby to be update)

```
EMOJI
< 3      ♥   heart
: )      ☺   happy
: (      ☹   sad
p o o    💩  poop
F U      🖕  middle finger
\ o /    🙌  celebration
C C C P  ☭   comunism

SYMBOL
o c    ©  copyright
o r    ®  registered
o o    °  degree
T m    ™  trademark
( 1 )  ①  circled [0-50A-za-z]

DRAWING
^ -  ¯ upper line
< -  ← left arrow
v |  ↓ down arrow
^ |  ↑ up arrow
- >  → right arrow
= >  ⇒ double right arrow

MATH/LOGIC
+ -  ±  plus-mius
! ?  ‽  interrobang
m u  µ  micro
, -  ¬  not
1 2  ½  one over [1-5]
x x  ×  multiply
^ 0  ⁰  superscript n
_ 0  ₀  subscript n
> =  ≥  greater than or equal
< =  ≤  less than or equal
v /  √  square root
8 8  ∞  infinity
~ ~  ≈  approx
= _  ≡  indentical
```

full (default) list for xorg is at https://cgit.freedesktop.org/xorg/lib/libX11/plain/nls/en_US.UTF-8/Compose.pre

