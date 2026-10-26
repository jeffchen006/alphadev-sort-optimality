# n=5 model=out iset=I1 prefix14_class=2057
cmp P2, P0
cmovle S1, P0
cmovle P0, P2
cmovg S1, P2
cmp P3, P1
cmovg S0, P3
cmovg P3, P1
cmovg P1, S0
mov S2, P1
cmp S2, S1
cmovg P1, S1
cmovle S2, S1
mov S1, P0
cmp S1, P3
