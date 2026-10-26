# n=5 model=out iset=I1 prefix14_class=10958
cmp P3, P2
cmovl S2, P3
cmovl P3, P2
mov S0, P0
cmovl P2, S2
cmp P0, P1
cmovg P0, P1
cmovg P1, S0
cmp P1, P3
cmovge S0, P3
cmovge P3, P1
cmovl S0, P1
cmp P2, P0
cmovle P1, P0
