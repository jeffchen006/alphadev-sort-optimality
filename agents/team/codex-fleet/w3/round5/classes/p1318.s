# n=5 model=out iset=I1 prefix14_class=1318
mov S0, P3
cmp P1, S0
cmovge S0, P1
cmovle P3, P1
mov P1, S0
mov S2, P0
cmp S2, P2
cmovg S2, P2
cmovg P2, P0
cmp P2, S0
cmovge S0, P2
cmovl P1, P2
cmp S2, P3
mov P2, P1
