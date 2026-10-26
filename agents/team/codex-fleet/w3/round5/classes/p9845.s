# n=5 model=out iset=I1 prefix14_class=9845
mov S0, P3
cmp P3, P1
cmovle S0, P1
cmovl P1, P3
cmp P2, P0
cmovge S2, P2
cmovge P2, P0
cmovg P0, S2
cmp S0, P0
cmovle P3, S0
cmovl S0, P0
cmovg P3, P0
cmp P2, P1
mov P0, P1
