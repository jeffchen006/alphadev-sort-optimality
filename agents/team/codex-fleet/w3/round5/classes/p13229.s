# n=5 model=out iset=I1 prefix14_class=13229
cmp P3, P1
cmovle S0, P1
cmovle P1, P3
mov S1, P2
cmovle P3, S0
cmp P2, P0
cmovge P2, P0
cmovl S1, P0
mov S2, P2
cmp P1, P2
cmovl S2, P1
cmovl P1, P2
cmp P3, S1
mov S2, P1
