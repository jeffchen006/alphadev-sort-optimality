# n=5 model=out iset=I1 prefix14_class=11411
cmp P1, P0
cmovl S1, P0
cmovl P0, P1
cmovl P1, S1
cmp P3, P2
cmovle S2, P2
cmovle P2, P3
mov S0, P2
cmovge S2, P3
cmp P0, P2
cmovge P2, P0
cmovle S0, P0
cmovl P0, P2
mov P3, P1
