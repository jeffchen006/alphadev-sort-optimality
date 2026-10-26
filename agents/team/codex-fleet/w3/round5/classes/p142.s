# n=5 model=out iset=I1 prefix14_class=142
mov S0, P1
cmp S0, P3
cmovle P1, P3
cmovg S0, P3
cmp P0, P2
mov S1, P2
cmovle P2, P0
cmovg S1, P0
cmp P2, S0
mov S2, P2
cmovle P2, S0
cmovg S2, S0
mov P0, P2
mov P3, S1
