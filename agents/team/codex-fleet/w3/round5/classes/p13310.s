# n=5 model=out iset=I1 prefix14_class=13310
cmp P1, P2
cmovl S0, P2
cmovge S0, P1
cmovg P1, P2
cmp P0, P3
cmovle S1, P3
cmovle P3, P0
cmovl P0, S1
mov P2, P1
mov S2, S0
cmp P2, P3
cmovge P2, P3
cmovge P3, P1
cmp S2, P0
