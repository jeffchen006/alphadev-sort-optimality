# n=5 model=out iset=I1 prefix14_class=2381
cmp P0, P1
mov S2, P0
cmovge S2, P1
cmovg P1, P0
mov S1, P3
cmp P2, S1
cmovl S1, P2
mov S0, P1
cmovg P3, P2
cmp P1, P3
cmovl P1, P3
cmovle P3, S0
cmp S2, S1
cmovge P1, S2
