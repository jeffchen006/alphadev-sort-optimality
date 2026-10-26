# n=5 model=out iset=I1 prefix14_class=12005
mov S0, P2
cmp P3, P2
cmovg P2, P3
cmovl S0, P3
cmp P1, P0
cmovge S1, P1
cmovle S1, P0
cmovle P0, P1
cmp P0, S0
mov S2, S1
cmovl P3, S0
cmovl S0, P0
cmovl P0, P3
cmp P2, S2
