# n=5 model=out iset=I1 prefix14_class=13790
cmp P2, P0
cmovge S1, P2
cmovg P2, P0
mov S0, P1
cmovg P0, S1
cmp S0, P3
cmovl P1, P3
cmovg S0, P3
cmp P0, P1
cmovg P3, P0
cmovle P3, P1
cmovle P1, P0
cmp S0, P2
mov S2, P1
