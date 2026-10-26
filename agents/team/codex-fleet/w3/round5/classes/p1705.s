# n=5 model=out iset=I1 prefix14_class=1705
cmp P1, P3
cmovge S2, P1
cmovl S2, P3
cmovle P3, P1
cmp P2, P0
cmovle P1, P0
cmovl P0, P2
mov S0, P0
cmovl P2, P1
cmp P3, P0
cmovg P0, P3
cmovle S0, P3
cmp P2, S2
mov S0, S2
