# n=5 model=out iset=I1 prefix14_class=5283
cmp P2, P3
cmovge S0, P2
mov S2, P1
cmovge P2, P3
cmovle S0, P3
cmp P0, S2
cmovle S2, P0
cmovl P0, P1
cmp P2, S2
mov P3, S2
mov S1, S0
cmovl P3, P2
cmovl P2, S2
mov P3, P2
