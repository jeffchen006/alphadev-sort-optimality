# n=5 model=out iset=I1 prefix14_class=166
mov S1, P2
cmp S1, P3
cmovg S1, P3
cmovl P2, P3
mov P3, P0
cmp P1, P0
cmovle P0, P1
cmovl P1, P3
cmp S1, P0
mov S0, P0
cmovg S0, S1
cmovg S1, P0
mov S2, S0
cmp P2, P1
