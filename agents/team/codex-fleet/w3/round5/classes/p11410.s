# n=5 model=out iset=I1 prefix14_class=11410
cmp P2, P0
cmovl S1, P0
cmovl P0, P2
cmovl P2, S1
cmp P3, P1
cmovle S2, P1
cmovle P1, P3
cmovge S2, P3
mov S0, P1
cmp P0, P1
cmovge P1, P0
cmovle S0, P0
cmovl P0, P1
mov P3, P2
