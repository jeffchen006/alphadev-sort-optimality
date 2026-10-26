# n=5 model=out iset=I1 prefix14_class=7156
mov S0, P3
cmp P3, P1
cmovle S0, P1
cmovge P3, P1
cmp P0, P2
cmovle P1, P2
cmovl P2, P0
cmovl P0, P1
mov S2, P3
cmp P3, P2
cmovle P3, P2
cmovg S2, P2
cmp S0, P0
cmovge S2, P0
