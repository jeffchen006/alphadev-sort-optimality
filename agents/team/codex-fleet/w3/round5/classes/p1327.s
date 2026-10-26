# n=5 model=out iset=I1 prefix14_class=1327
cmp P1, P2
cmovl S0, P2
cmovl P2, P1
mov S2, P0
cmovge S0, P1
cmovle P1, S0
cmp P0, P3
cmovge P0, P3
cmovge P3, S2
cmp P3, P1
cmovg P1, P3
cmovle S0, P3
cmp P0, P2
cmovg P1, P2
