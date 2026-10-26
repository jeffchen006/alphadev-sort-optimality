# n=5 model=out iset=I1 prefix14_class=2968
mov S2, P2
cmp P0, P2
mov S1, P1
cmovle P2, P0
cmovg S2, P0
cmp S1, P3
cmovge P1, P3
cmovge P3, S1
cmp P3, S2
mov S0, S2
cmovl S2, P3
cmovl P3, S0
cmp P1, P2
cmovle S0, S2
