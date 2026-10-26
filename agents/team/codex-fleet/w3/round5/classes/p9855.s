# n=5 model=out iset=I1 prefix14_class=9855
mov S1, P2
cmp P3, P2
cmovge S1, P3
cmovle P2, P3
cmp P0, P1
cmovge S2, P1
cmovg P1, P0
mov S0, S1
cmovg P0, S2
cmp P1, S0
cmovl S1, P1
cmovl P1, S0
mov P1, S1
cmp P0, P2
