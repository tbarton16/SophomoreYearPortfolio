/* Spamventure! */
%% starter file by Ran Libeskind-Hadas
%% and modified by Z Dodds
%% now modified by CS60DF
/*



  Comments on your game should go here -- including how to "solve" it
     -- and anything else the graders should know (extras)
*/
% some "nice" prolog settings...  see assignment 8's
% description for the details on what these do
% -- but it's not crucial to know the details of these Prolog internals
:- set_prolog_flag( prompt_alternatives_on, groundness ).
:- set_prolog_flag(toplevel_print_options, [quoted(true), 
     portray(true), attributes(portray), max_depth(999), priority(699)]).




%% thing_at(X, Y) will be true iff thing X is at location Y.
%% player_at(X) will be true iff player is at location X.
%% The use of dynamic should be at the beginning of the file when
%% we plan to mix static and dynamic facts with the same names.

:- dynamic thing_at/2, player_at/1.

%% The player is initially at medina
player_at(constantinople).

%% thing_at(X, Y) is true iff thing X is at location Y.
%% note that the key is not described at medina and
%% the spam is described along with cairo
%% both of these are problems -- you might start by considering
%% how you might fix them... (see cairo for a similar note)
thing_at(key, medina).         
thing_at(spam, constantinople).    
thing_at(micro_usb, medina).

%% path(X, Y, Z) is true iff there is a path from X to Z via direction Y.
path(medina, north, constantinople).   
path(medina, south, cairo).
path(cairo, north, medina).
path(constantinople, south, medina).
path(mostar, west, vienna).
path(vienna,east,mostar).
path(mostar, west, constantinople).
path(constantinople,east,mostar).





%% This is how one can take an object.
take(X) :- 
    thing_at(X, in_hand),
    nl, write('You are already holding that.'),
    nl.  /* new line */
take(X) :- 
    player_at(Place),
    thing_at(X, Place),
    thing_at(Z,in_hand),
    thing_at(P,in_hand),
    Z \== P,
    nl, write(' You cannot take that.Be occupied, then, with what you really value and let the thief take something else.'), nl.


take(X) :-
    player_at(Place),
    thing_at(X, Place),
    retract(thing_at(X, Place)),
    assert(thing_at(X, in_hand)),
    nl, write('you have' ),
    write(X),
    nl.
drop(X) :- 
    \+thing_at(X,in_hand),
    nl, write('That does not exist in your caravan '),
    nl.
drop(X) :-
    player_at(Place),
    thing_at(X, in_hand),
    retract(thing_at(X, in_hand)),
    assert(thing_at(X, Place)),
    nl, write('Do not grieve. Anything you lose comes round in another form. '),
    write(X),
    nl.

%% This is how we move.
north :- go(north).
south :- go(south).
east :- go(east).
west :- go(west).

go(Direction) :-
    player_at(Here),
    path(Here, Direction, There),
    retract(player_at(Here)),
    assert(player_at(There)),
    nl, write('OK, you are now walking to '),
    write(There), nl,
    look.

go(Direction) :-
    player_at(Here),
    \+path(Here, Direction, _),
    write('You cannot go that way.'), nl.


%% The predicates used to describe a place

look :- nl, player_at(Place),describe(Place), nl,
\+things_at(Place), \+can_go(Place)
.

inventory :- nl, thing_at(X, in_hand), write(X),nl,fail.

%fail at end, fail with caution!

things_at(Place):- thing_at(X,Place),describe_thing(X),fail.

describe_thing(key):- 
    write('There is a Key here'), nl.
describe_thing(spam):-
    write('There is a can of Spam at your feet!'), nl.
describe_thing(micro_usb):- 
    write('There is a a micro usb here'), nl.

can_go(Place):- path(Place, Direction, There), describe_place(Direction, There),fail, nl.

describe_place(Direction,There):-
	write('to the '),
	write(Direction),
	write(' you see '),
	write(There), nl.

describe(medina) :- 
    write('You are in Medina'), nl,
    write('You can hear the call to prayer from the muezzin'), nl,
    write('Prolog is so much fun!').

describe(constantinople) :- 
    write('You are in Istanbul.'), nl,
    write('There are algebrars here.'), nl,
    write('One of them wants a fourier transform --'), nl,
    write('and wants it fast!').

describe(platt) :- 
    write('You are in Platt.'), nl,
    write('Jays Place has good pizza.').

describe(platt) :- 
    write('You are in Platt.'), nl,
    write('Jays Place has good pizza.').

describe(vienna) :- 
    write('You are with the janaissairies besieging the Hapsburg fortress of Vienna'), nl,
    write('Jays Place has good pizza.').

describe(cairo) :- 
    write('You are standing amidst the grand warehouses of Cairo.'), nl,
    write('It is probably best not to describe this place.'), nl.


%% The predicates used to start the game
%% You should customize these instructions to reveal
%% the object of your adventure along with any special 
%% commands the user might need to know.
start :- instructions, look.

instructions :- nl,
    write('You are the great Ottoman traveler Evliya Celebi'), nl,
    write('Your Quest is to bring exotic gifts to flatter the Sultan, you need to gather mystery items from the east to find clues of what items in the west lead to enlightenment. And because it has been said: I looked in temples, churches & mosques. I found the Divine within my Heart, you need to return to the city of your heart to discover the last clue. ' ), nl,
    write('Type east, west, north, or south to journey there.'), nl,
    write('As you start to walk out on the way, the way appears.'), nl.


% run this test by typing run_tests(play)
:- begin_tests(play).
test(play1) :- start,
	      go(north),
	      go(south),
	      player_at(medina), !.

:- end_tests(play).