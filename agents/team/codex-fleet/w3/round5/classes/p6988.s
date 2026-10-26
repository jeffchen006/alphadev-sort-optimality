# n=5 model=out iset=I1 prefix14_class=6988
mov S0, P2
cmp P1, S0
mov S1, P0
cmovle S0, P1
cmovg P2, P1
cmp P3, S1
mov S2, S0
cmovl P0, P3
cmovle P3, S1
cmp P0, S2
cmovl S2, P0
cmovl P0, S0
cmp P2, P3
cmovge S1, P2
