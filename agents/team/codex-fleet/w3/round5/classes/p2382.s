# n=5 model=out iset=I1 prefix14_class=2382
mov S2, P2
cmp P2, P1
cmovg S2, P1
cmovg P1, P2
mov S1, P3
cmp P0, S1
cmovg P3, P0
mov S0, P1
cmovle S1, P0
cmp P1, P3
cmovl P1, P3
cmovle P3, S0
cmp S2, S1
mov P1, S2
