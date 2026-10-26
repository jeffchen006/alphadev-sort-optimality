# n=5 model=out iset=I1 prefix14_class=10300
cmp P1, P0
mov S1, P1
cmovg S1, P0
cmovle P1, P0
mov S2, P1
cmp P2, P3
cmovg S0, P3
cmovg P3, P2
cmovg P2, S0
cmp P3, S2
cmovle P1, P3
cmovg S2, P3
cmp P2, S1
mov P3, P1
