# n=5 model=out iset=I1 prefix14_class=5347
mov S2, P1
cmp P2, P1
mov S0, P3
cmovge P1, P2
cmovle S2, P2
cmp P0, P3
cmovl S0, P0
cmovg P3, P0
cmp S0, S2
cmovle P0, S0
cmovl S0, S2
cmovle S2, P0
cmp P3, P1
cmovle P0, P3
