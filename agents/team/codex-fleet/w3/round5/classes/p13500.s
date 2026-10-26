# n=5 model=out iset=I1 prefix14_class=13500
mov S1, P1
cmp P3, P0
cmovle S2, P3
cmovl P3, P0
cmovle P0, S2
cmp P2, S1
cmovl S1, P2
cmovge P1, P2
mov S0, S1
cmp P0, S1
cmovle S1, P0
mov S1, P1
cmovl P0, S0
cmp P3, S1
