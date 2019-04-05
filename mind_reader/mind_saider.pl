
play:-
	write('Select a country from the list and keep it in your mind'),nl,
	write('# Bangladesh \n'),
	write('# India\n'),
	write('# Pakistan\n'),
	write('# Australia\n'),
	write('# England\n'),
	write('# Brazil\n'),
	write('# Bhutan\n'),
	write('# China\n'),
	write('# Iran\n'),
	write('# Japan\n'),
	write('# Nepal\n'),
	write('# Sri Lanka\n\n\n'),
	find1to6.

replay(Ans):-
	read(Ans),
	write(Ans),nl.

find1to6:-
	write('Is it in here? (y/n)'),nl,
	write('# Bangladesh \n'),
	write('# India\n'),
	write('# Pakistan\n'),
	write('# Australia\n'),
	write('# England\n'),
	write('# Brazil\n\n'),
	replay(Ans),
	Ans='y',
	find1to3.
find1to6:-
	find7to9.

find1to3:-
	write('Is it in here? (y/n)\n'),
	write('# Bangladesh \n'),
	write('# India\n'),
	write('# Pakistan\n'),
	write('# Japan\n'),
	write('# Nepal\n'),
	write('# Sri Lanka\n\n'),
	replay(Ans),
	Ans='y',
	find12.
find1to3:-
	find45.

find12:-
	write('Is it in here? (y/n)\n'),
	write('# Brazil\n'),
	write('# Bangladesh \n'),
	write('# India\n'),
	write('# Bhutan\n'),
	write('# China\n'),
	write('# Iran\n\n'),
	replay(Ans),
	Ans='y',
	find1.
find12:-
	write('Your Selected Number is Pakistan\n'),nl.%3

find1:-
	write('Is it in here? (y/n)\n'),
	write('# England\n'),
	write('# Brazil\n'),
	write('# Bhutan\n'),
	write('# China\n'),
	write('# Iran\n'),
	write('# Bangladesh\n\n'),nl,
	replay(Ans),
	Ans='y',
	write('Your Selected Number is Bangladesh\n'),nl.%1
find1:-
	write('Your Selected Number is India\n'),nl.%2


find45:-
	write('Is it in here? (y/n)\n'),
	write('# Australia\n'),
	write('# England\n'),
	write('# Bhutan\n'),
	write('# China\n'),
	write('# Iran\n'),
	write('# Japan\n\n'),
	replay(Ans),
	Ans='y',
	find4.
find45:-
	write('Your Selected Number is Brazil\n'),nl.%6

find4:-
	write('Is it in here? (y/n)\n'),
	write('# Australia'),nl,
	write('# Bhutan\n'),
	write('# China\n'),
	write('# Iran\n'),
	write('# Japan\n'),
	write('# Nepal\n\n'),
	replay(Ans),
	Ans='y',
	write('Your Selected Number is Australia\n'),nl.%4
find4:-
	write('Your Selected Number is England\n'),nl.%5



find7to9:-
	write('Is it in here? (y/n)\n'),
	write('# Bhutan\n'),
	write('# China\n'),
	write('# Iran\n'),
	write('# Bangladesh \n'),
	write('# India\n'),
	write('# Pakistan\n\n'),
	replay(Ans),
	Ans='y',
	find78.
find7to9:-
	find10to11.

find78:-
	write('Is it in here? (y/n)\n'),
	write('# Bhutan\n'),
	write('# China\n'),
	write('# Pakistan\n'),
	write('# Australia\n'),
	write('# England\n'),
	write('# Brazil\n\n'),
	replay(Ans),
	Ans='y',
	find7.
find78:-
	write('Your Selected Number is Iran\n'),nl.%9

find7:-
	write('Is it in here? (y/n)\n'),
	write('# Brazil\n'),
	write('# Bhutan'),nl,
	write('# Bangladesh \n'),
	write('# India\n'),
	write('# Pakistan\n'),
	write('# Australia\n\n'),
	replay(Ans),
	Ans='y',
	write('Your Selected Number is Bhutan\n'),nl.%7
find7:-
	write('Your Selected Number is China\n'),nl.%8


find10to11:-
	write('Is it in here? (y/n)\n'),

	write('# Bangladesh \n'),
	write('# India\n'),
	write('# Pakistan\n'),
	write('# Australia\n'),
	write('# Japan\n'),
	write('# Nepal\n\n'),
	replay(Ans),
	Ans='y',
	find10.
find10to11:-
	write('Your Selected Number is Sri Lanka\n'),nl.%12

find10:-
	write('Is it in here? (y/n)\n'),
	write('# Japan\n'),
	write('# India\n'),
	write('# Pakistan\n'),
	write('# Australia\n'),
	write('# England\n'),
	write('# Brazil\n\n'),
	replay(Ans),
	Ans='y',
	write('Your Selected Number is Japan\n'),nl.%10
find10:-
	write('Your Selected Number is Nepal\n'),nl.%11





