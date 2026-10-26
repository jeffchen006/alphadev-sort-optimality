# n=5 model=out iset=I1 prefix14_class=2054
cmp P3, P0
mov S1, P0
cmovle P0, P3
cmovg S1, P3
cmp P2, P1
mov S2, P2
cmovg P2, P1
cmovg P1, S2
mov S0, P1
cmp S0, S1
cmovle S0, S1
cmovg P1, S1
mov S1, P2
cmp S1, P0
