# n=5 model=out iset=I1 prefix14_class=6552
cmp P1, P3
mov S1, P1
cmovl S1, P3
mov S0, S1
cmovg P1, P3
cmp P2, P0
cmovle S2, P2
cmovl P2, P0
cmovl P0, S2
cmp P2, S0
cmovle S0, P2
cmovge S1, P2
cmp P0, P1
cmovg S1, P0
