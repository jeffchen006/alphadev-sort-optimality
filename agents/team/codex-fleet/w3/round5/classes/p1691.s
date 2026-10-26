# n=5 model=out iset=I1 prefix14_class=1691
cmp P0, P2
cmovle S2, P2
cmovge S2, P0
mov S0, P1
cmovl P2, P0
cmp P3, P1
cmovle P1, P3
cmovle P3, S0
cmovl S0, P1
cmp P2, P1
cmovg P1, P2
cmovl S0, P2
mov S0, S2
cmp P3, S0
