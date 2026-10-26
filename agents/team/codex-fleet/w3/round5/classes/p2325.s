# n=5 model=out iset=I1 prefix14_class=2325
mov S0, P1
mov S1, P3
cmp P1, P0
cmovle P1, P0
cmovg S0, P0
cmp S1, P2
cmovl S1, P2
cmovge P3, P2
cmp P1, S1
cmovg S2, P1
cmovle S2, S1
cmovle S1, P1
cmp P3, S0
cmovl S2, S0
