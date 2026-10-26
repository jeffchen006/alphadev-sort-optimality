# n=5 model=out iset=I1 prefix14_class=11414
mov S1, P3
cmp P0, P1
cmovl S2, P1
cmovle P1, P0
cmovl P0, S2
mov S0, P1
cmp P3, P2
cmovg P3, P2
cmovge P2, S1
cmp P1, P3
cmovle S0, P3
cmovge P1, P3
mov P3, P0
cmp P3, P2
