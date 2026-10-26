# n=5 model=out iset=I1 prefix14_class=132
mov S1, P0
mov S0, P2
cmp S1, P1
cmovle P0, P1
cmovg S1, P1
cmp P3, S0
mov S2, S1
cmovg S0, P3
cmovle P2, P3
cmp P2, S2
mov P1, S0
cmovle S2, P2
cmovle P2, S1
mov S2, P2
