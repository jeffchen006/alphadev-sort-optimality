# n=5 model=out iset=I1 prefix14_class=471
cmp P2, P0
mov S0, P1
mov S1, P2
cmovl S1, P0
cmovle P0, P2
cmp P1, P3
cmovg P1, P3
cmovge P3, S0
cmp P1, P0
cmovle S0, P0
mov S2, P3
cmovl P0, P1
cmovle P1, S0
mov P0, P1
