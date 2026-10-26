# n=5 model=out iset=I1 prefix14_class=13731
mov S2, P0
cmp P1, P3
cmovle S0, P3
cmovl P3, P1
cmovle P1, S0
cmp S2, P2
cmovg P0, P2
cmovl S2, P2
cmp S2, P1
cmovge P2, P1
mov S1, P0
cmovge P1, S2
cmovge S2, P2
cmp S1, P3
