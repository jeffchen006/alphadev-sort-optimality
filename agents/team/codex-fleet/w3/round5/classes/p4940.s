# n=5 model=out iset=I1 prefix14_class=4940
cmp P3, P2
cmovge S0, P3
cmovl S0, P2
mov S1, P0
cmovg P3, P2
cmp S1, P1
cmovl P0, P1
mov P2, P3
cmovl P1, S1
cmp P3, P1
cmovge P3, P1
cmovge P1, P2
cmp S0, P0
cmovle S2, P0
