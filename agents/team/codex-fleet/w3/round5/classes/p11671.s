# n=5 model=out iset=I1 prefix14_class=11671
mov S0, P1
cmp P1, P0
cmovl S0, P0
cmovg P1, P0
cmp P3, P2
cmovl P0, P2
mov S1, S0
cmovle P2, P3
cmovl P3, P0
cmp P3, S0
mov S2, P2
cmovge S1, P3
cmovle S0, P3
cmp P1, P2
