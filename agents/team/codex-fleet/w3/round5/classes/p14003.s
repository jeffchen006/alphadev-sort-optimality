# n=5 model=out iset=I1 prefix14_class=14003
cmp P3, P2
cmovle S2, P3
cmovge S2, P2
mov S1, P0
cmovl P3, P2
cmp P1, P0
mov S0, S2
cmovl S1, P1
cmovge P0, P1
cmp P3, P0
cmovle P1, P3
cmovl P3, P0
cmovle P0, P1
mov P2, P0
