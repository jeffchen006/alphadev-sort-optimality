# n=5 model=out iset=I1 prefix14_class=8946
cmp P0, P2
cmovge S2, P0
cmovg P0, P2
cmovl S2, P2
cmp P1, P3
mov S0, P1
cmovl P1, P3
cmovl P3, S0
cmp P1, S2
mov S1, P1
cmovle S1, S2
cmovg P1, S2
cmp P0, P3
cmovle S2, P3
