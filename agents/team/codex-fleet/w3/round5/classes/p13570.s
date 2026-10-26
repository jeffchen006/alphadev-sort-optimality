# n=5 model=out iset=I1 prefix14_class=13570
cmp P2, P1
cmovl S2, P2
cmovl P2, P1
cmovl P1, S2
cmp P0, P3
cmovge S0, P3
cmovle S0, P0
cmovl P0, P3
mov P3, P1
cmp S0, P3
cmovge P1, S0
cmovg S0, P3
cmp P2, P0
cmovl S1, P2
