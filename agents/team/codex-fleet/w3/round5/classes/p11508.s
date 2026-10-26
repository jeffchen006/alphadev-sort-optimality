# n=5 model=out iset=I1 prefix14_class=11508
mov S0, P0
cmp P2, P0
cmovg P0, P2
mov S2, P3
cmovle S0, P2
cmp S2, P1
cmovl S2, P1
cmovg P3, P1
cmp S0, P3
cmovl P2, S0
cmovl S0, P3
cmovge P2, P3
cmp S2, P0
cmovle P3, S0
