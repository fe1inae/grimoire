# plan9 text interface

the entire plan9 system centers around text manipulation, though the most
notable is certainly acme. it is a mouse driven interface focused on
executing external programs to modify its contents. i am quite a fan of
it philosophically, but i just cant get used to going back and forth to a
mouse, not sure if its just my setup but it hurts my wrist. too much fps
gaming in prior maybe, i have to be careful.

since acme specializes in executing text, it can be composed to be quite
interactive, allowing buttons and menus in a very transparent simple way.
i have yet to find a program that uses a keyboard which compares in this
aspect, sadly.

without even using acme, plan9s terminal does not implement vt100
sequences at all. doesnt even have readline-esque bindings, just a "dumb"
output. this is made up for with its window managers, rio, ability to
"swallow" child processes started from the terminal. this means that from
the users perspective, assuming the interface of the program is simple,
its just a rich text interface.  this is probably the ideal imo and one
of my favorite things in this realm from plan9, it makes the desktop
workflow so much more fluent just with that single feature.

overall plan9 is focused on text interfaces, so just read about plan9
itself.