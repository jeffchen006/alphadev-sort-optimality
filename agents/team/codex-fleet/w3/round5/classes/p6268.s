# n=5 model=out iset=I1 prefix14_class=6268
mov S1, P3
mov S2, P0
cmp P1, S1
cmovl S1, P1
cmovl P1, P3
cmp P2, S2
cmovge P0, P2
mov S0, P1
cmovl S2, P2
cmp P0, S0
cmovle S0, P0
cmovle P0, P1
mov P1, S0
mov P0, S2
