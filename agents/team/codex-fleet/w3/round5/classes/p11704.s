# n=5 model=out iset=I1 prefix14_class=11704
cmp P2, P0
cmovl S1, P2
cmovl P2, P0
mov S0, P3
cmovl P0, S1
cmp P1, P3
cmovge S0, P1
cmovl P3, P1
cmp P2, S0
cmovg P1, S0
cmovle P1, P2
cmovle P2, S0
cmp P0, P3
cmovg S2, P0
