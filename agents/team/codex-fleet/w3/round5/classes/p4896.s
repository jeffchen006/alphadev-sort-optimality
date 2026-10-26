# n=5 model=out iset=I1 prefix14_class=4896
cmp P1, P2
cmovle S0, P1
cmovl P1, P2
mov S2, P3
cmovle P2, S0
cmovg S0, P2
cmp P0, P3
cmovl S2, P0
cmovl P0, P3
cmp S2, S0
cmovg S0, S2
cmovg S2, P2
cmp P1, P0
cmovge P3, P0
