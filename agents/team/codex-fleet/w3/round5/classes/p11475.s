# n=5 model=out iset=I1 prefix14_class=11475
cmp P1, P0
cmovle S2, P0
cmovg S2, P1
cmovl P0, P1
cmp P3, P2
mov S1, P3
cmovge S1, P2
cmovge P2, P3
mov P1, P2
cmp P0, S1
cmovle S0, P0
cmovl P0, S1
cmovl S1, S0
mov P3, P0
