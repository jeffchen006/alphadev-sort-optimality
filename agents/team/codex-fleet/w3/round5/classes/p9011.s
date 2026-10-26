# n=5 model=out iset=I1 prefix14_class=9011
cmp P1, P2
mov S1, P3
cmovge S0, P1
cmovle S0, P2
cmovge P1, P2
cmp P0, S1
cmovl P3, P0
cmovle P0, S1
cmp S0, P0
cmovge P2, P0
cmovg P0, S0
cmovge S0, P2
cmp P3, P1
cmovl S1, P1
