# n=5 model=out iset=I1 prefix14_class=6599
mov S0, P2
cmp P1, S0
cmovl P2, P1
cmovg S0, P1
cmp P0, P3
mov S2, P0
cmovle P0, P3
mov P1, P0
cmovl P3, S2
cmp S0, P0
cmovg P0, S0
cmovg S0, P1
cmp P2, P3
cmovge S1, P3
