# n=5 model=out iset=I1 prefix14_class=7623
cmp P0, P2
cmovle S1, P0
cmovl P0, P2
cmovle P2, S1
mov S2, P3
cmp S2, P1
cmovg S2, P1
cmovge P1, P3
cmp P2, S2
mov S0, P2
cmovge S0, S2
mov S0, P0
cmovg S2, P2
cmp P1, P0
