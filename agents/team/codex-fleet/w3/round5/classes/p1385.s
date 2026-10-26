# n=5 model=out iset=I1 prefix14_class=1385
mov S0, P0
cmp P1, S0
cmovg P0, P1
cmovl S0, P1
mov S1, P2
cmp S1, P3
mov P1, P0
cmovge S1, P3
cmovg P3, P2
cmp P3, P0
cmovle P1, P3
cmovl P3, P0
mov P3, P1
mov P2, S0
