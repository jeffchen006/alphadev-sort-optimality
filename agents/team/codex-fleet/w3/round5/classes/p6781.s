# n=5 model=out iset=I1 prefix14_class=6781
cmp P3, P1
mov S2, P1
mov S0, P2
cmovge S2, P3
cmovle P1, P3
cmp P2, P0
cmovl P2, P0
cmovg S0, P0
cmp S2, P2
cmovg P0, S2
cmovg S2, P2
cmovg P2, P0
mov P2, S0
cmp S0, P1
