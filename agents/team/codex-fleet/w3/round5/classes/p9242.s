# n=5 model=out iset=I1 prefix14_class=9242
cmp P0, P2
cmovl S0, P2
cmovge S0, P0
mov S1, P1
cmovl P2, P0
cmp P3, S1
cmovge S1, P3
cmovl P1, P3
cmp P1, P2
cmovle S2, P2
cmovle P2, P1
cmovle P1, S2
mov P2, S1
mov P3, P1
