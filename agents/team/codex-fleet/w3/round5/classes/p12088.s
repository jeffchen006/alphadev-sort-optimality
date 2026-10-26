# n=5 model=out iset=I1 prefix14_class=12088
cmp P2, P1
cmovge S0, P1
cmovle S0, P2
cmovg P1, P2
cmp P3, P0
cmovge P2, P0
cmovle P2, P3
mov S2, P1
cmovl P3, P0
cmp S0, P2
cmovle P0, S0
cmovl S0, P2
cmovle P2, P0
mov S1, S0
