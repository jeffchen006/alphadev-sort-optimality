# n=5 model=out iset=I1 prefix14_class=10650
cmp P2, P0
cmovl S2, P0
mov S1, P3
cmovle P0, P2
cmovl P2, S2
mov S0, P2
cmp P1, S1
cmovge S1, P1
cmovg P1, P3
cmp S0, S1
cmovge P2, S1
mov P3, P1
cmovge S1, S0
cmp P0, P3
