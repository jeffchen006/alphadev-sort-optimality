# n=5 model=out iset=I1 prefix14_class=768
mov S2, P3
mov S1, P1
cmp P0, P1
cmovle S1, P0
cmovl P0, P1
cmp P3, P2
cmovl S2, P2
cmovge P3, P2
cmp P0, S2
cmovge S0, P0
cmovle S0, S2
cmovl S2, P0
mov P1, S2
mov S0, S1
