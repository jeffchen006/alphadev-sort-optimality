# n=5 model=out iset=I1 prefix14_class=5258
mov S2, P3
cmp P2, P0
mov S0, P2
cmovg P2, P0
cmovle S0, P0
cmp P1, S2
mov P0, P2
cmovl P3, P1
cmovle P1, S2
cmp P3, P2
cmovg P2, P3
cmovge P3, P0
cmp S0, P1
cmovl S2, S0
