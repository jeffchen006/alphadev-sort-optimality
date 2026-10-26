# n=5 model=out iset=I1 prefix14_class=988
mov S2, P0
cmp P2, S2
cmovg S2, P2
cmovle P0, P2
mov P2, P3
cmp P2, P1
cmovg P2, P1
cmovg P1, P3
mov S1, P1
cmp S2, P1
cmovg S1, S2
mov S0, P2
cmovg S2, P1
cmp P0, S0
