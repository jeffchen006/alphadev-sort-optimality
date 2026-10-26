# n=5 model=out iset=I1 prefix14_class=1939
mov S0, P3
mov S2, P2
cmp P1, P3
cmovle S0, P1
cmovle P1, P3
cmp P0, P2
cmovl P2, P0
cmovl P0, S2
cmp P0, P1
cmovge S2, P1
cmovl S2, P0
cmovge P1, P0
cmp P2, S0
cmovge P3, P2
