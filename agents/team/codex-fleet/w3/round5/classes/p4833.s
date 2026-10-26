# n=5 model=out iset=I1 prefix14_class=4833
cmp P0, P2
cmovle S2, P2
cmovg S2, P0
cmovl P2, P0
cmp P1, P3
cmovge S1, P1
cmovg P1, P3
cmovg P3, S1
mov S0, P2
cmp P1, P2
cmovge S0, P1
cmovl P2, P1
mov P0, S0
mov P2, P3
