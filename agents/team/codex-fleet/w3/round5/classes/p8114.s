# n=5 model=out iset=I1 prefix14_class=8114
mov S2, P2
cmp P3, S2
cmovle S2, P3
cmovl P3, P2
cmp P0, P1
mov S0, S2
cmovle P2, P1
cmovl P1, P0
cmovle P0, P2
cmp S0, P1
cmovg S2, P1
cmovl S0, P1
cmp P3, P0
cmovge P1, P3
