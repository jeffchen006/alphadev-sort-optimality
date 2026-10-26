# n=5 model=out iset=I1 prefix14_class=4654
cmp P3, P0
cmovge S1, P3
cmovge P3, P0
cmovle S1, P0
cmp P2, P1
cmovle S0, P1
mov P0, S1
cmovl P1, P2
cmovl P2, S0
cmp S1, P2
cmovg P0, P2
cmovl S1, P2
cmp P1, P3
cmovge S0, P1
