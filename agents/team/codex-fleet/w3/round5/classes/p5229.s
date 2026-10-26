# n=5 model=out iset=I1 prefix14_class=5229
mov S1, P1
mov S0, P0
cmp P0, P3
cmovl S0, P3
cmovg P0, P3
cmp P2, P1
cmovle S1, P2
cmovl P2, P1
cmp P0, S1
mov P1, P0
cmovl P0, S1
cmovge P1, S1
cmp P2, S0
cmovge S1, P2
