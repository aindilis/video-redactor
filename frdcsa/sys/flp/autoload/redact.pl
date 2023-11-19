redacted(Term) :-
	classifiedTerm(Term).

redactedAtoms(Atoms) :-
	findall(Atom,
		(
		 redacted(Atom),
		 atom(Atom)
		),
		Atoms).

redactedTerms(Terms) :-
	findall(Term,redacted(Term),Terms).
