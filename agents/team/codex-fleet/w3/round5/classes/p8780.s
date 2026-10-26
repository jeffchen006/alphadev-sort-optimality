# n=5 model=out iset=I1 prefix14_class=8780
cmp P3, P2
cmovl S2, P2
cmovl P2, P3
cmovl P3, S2
mov S0, P1
cmp P0, S0
cmovle P1, P0
cmovge S0, P0
cmp P3, S0
mov S1, P3
cmovg P3, S0
cmovge S0, S1
cmp P1, P2
cmovg P0, P1
