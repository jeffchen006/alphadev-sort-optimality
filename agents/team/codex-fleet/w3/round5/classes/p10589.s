# n=5 model=out iset=I1 prefix14_class=10589
cmp P0, P2
cmovg S0, P0
cmovg P0, P2
mov S2, P3
cmovg P2, S0
cmp P1, S2
cmovge S2, P1
cmovle P3, P1
cmovl P1, S2
cmp P1, P2
cmovl P1, P2
cmovle P2, S2
cmp P0, P3
cmovl S2, P2
