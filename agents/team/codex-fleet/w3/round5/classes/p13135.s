# n=5 model=out iset=I1 prefix14_class=13135
mov S1, P2
cmp P2, P0
cmovle S1, P0
cmovge P2, P0
cmp P3, P1
cmovl S2, P3
cmovl P3, P1
mov S0, P2
cmovl P1, S2
cmp S0, P1
cmovge S0, P1
cmovg P1, P2
cmp P3, S1
cmovl S2, S1
