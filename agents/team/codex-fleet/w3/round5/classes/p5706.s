# n=5 model=out iset=I1 prefix14_class=5706
mov S0, P0
cmp P0, P2
mov S2, P3
cmovg S0, P2
cmovg P2, P0
cmp P1, S2
cmovge S2, P1
cmovle P3, P1
cmp P3, S0
cmovl P0, S0
cmovl S0, P3
cmovl P3, P0
mov S1, P3
cmp P2, S2
