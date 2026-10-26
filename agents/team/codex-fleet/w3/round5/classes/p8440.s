# n=5 model=out iset=I1 prefix14_class=8440
mov S0, P1
cmp P1, P2
cmovl P1, P2
cmovge S0, P2
mov S1, P3
cmp P3, P0
cmovg S1, P0
cmovle P3, P0
cmp P1, P3
cmovg S2, P3
cmovge P3, P1
mov P0, S0
cmovg P1, S2
cmp S0, S1
