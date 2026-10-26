# n=5 model=out iset=I1 prefix14_class=1399
cmp P2, P0
cmovle S1, P2
mov S0, P3
cmovl P2, P0
cmovg S1, P0
cmp P1, S0
cmovge S0, P1
cmovl P3, P1
mov S2, P2
cmp P2, S0
cmovl P2, S0
cmovl S0, S2
mov P2, P3
cmp P3, S1
