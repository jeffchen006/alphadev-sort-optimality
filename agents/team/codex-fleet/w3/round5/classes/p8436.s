# n=5 model=out iset=I1 prefix14_class=8436
mov S2, P3
cmp P0, S2
cmovg P3, P0
cmovle S2, P0
cmp P1, P2
cmovl S0, P2
cmovge S0, P1
cmovle P2, P1
cmp P3, S0
mov P1, P3
cmovl P1, S0
cmovge P3, S0
cmp P2, S2
mov P1, P3
