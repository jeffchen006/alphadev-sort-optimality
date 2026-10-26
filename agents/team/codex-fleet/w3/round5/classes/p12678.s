# n=5 model=out iset=I1 prefix14_class=12678
cmp P0, P3
mov S2, P3
cmovg S2, P0
cmovg P0, P3
cmp P1, P2
cmovl P3, P2
cmovle P2, P1
cmovl P1, P3
mov S1, P1
cmp P2, P0
mov S0, P2
cmovle P2, P0
cmovg S0, P0
cmp S2, P1
