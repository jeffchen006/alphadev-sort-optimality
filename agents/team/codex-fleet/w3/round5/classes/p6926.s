# n=5 model=out iset=I1 prefix14_class=6926
cmp P0, P2
cmovge S0, P0
mov S1, P1
cmovg P0, P2
cmovl S0, P2
cmp P1, P3
cmovle P1, P3
cmovl P3, S1
cmp P1, S0
mov S2, P3
cmovle P2, S0
cmovl S0, P1
cmovle P1, P2
mov P1, S0
