# n=5 model=out iset=I1 prefix14_class=196
mov S2, P3
cmp S2, P2
mov S0, P0
cmovl P3, P2
cmovle P2, S2
cmovle S2, P3
cmp S0, P1
cmovg S0, P1
cmovge P1, P0
cmp P2, S0
cmovl P0, P2
cmovle P2, S0
cmovl S0, P0
cmp P3, P1
