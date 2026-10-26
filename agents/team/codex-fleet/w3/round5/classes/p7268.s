# n=5 model=out iset=I1 prefix14_class=7268
cmp P2, P1
mov S0, P3
cmovl S2, P2
cmovl P2, P1
cmovl P1, S2
cmp P0, S0
cmovle S0, P0
cmovle P0, P3
cmp S0, P1
cmovg P3, P1
cmovle P3, S0
cmovge P1, S0
cmp P2, P0
mov P3, P0
