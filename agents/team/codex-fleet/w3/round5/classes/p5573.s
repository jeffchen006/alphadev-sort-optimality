# n=5 model=out iset=I1 prefix14_class=5573
cmp P3, P1
cmovge S1, P1
cmovg P1, P3
cmovg P3, S1
mov S0, P0
mov S2, P3
cmp P0, P2
cmovle P0, P2
cmovl P2, S0
cmovl S0, P0
cmp P2, P3
cmovl S2, P2
cmovge P3, P2
cmp S0, P1
