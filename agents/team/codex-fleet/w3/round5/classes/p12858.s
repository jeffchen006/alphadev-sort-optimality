# n=5 model=out iset=I1 prefix14_class=12858
cmp P1, P0
mov S0, P3
cmovge S1, P1
cmovge P1, P0
cmovg P0, S1
cmp P3, P2
cmovge P3, P2
mov S2, P3
cmovl S0, P2
cmp P3, P1
cmovle S2, P1
cmovl P1, P3
mov P1, S0
cmp S0, P0
