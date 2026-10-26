# n=5 model=out iset=I1 prefix14_class=2932
cmp P1, P0
mov S0, P3
cmovge S2, P0
cmovg P0, P1
cmovl S2, P1
cmp P2, P3
cmovge P3, P2
cmovg P2, S0
cmp P0, P3
cmovle S1, P3
cmovl P3, P0
cmovl P0, S1
mov P1, P3
mov S0, P2
