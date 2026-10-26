# n=5 model=out iset=I1 prefix14_class=2191
mov S0, P1
cmp P1, P2
mov S1, P0
cmovge P1, P2
cmovl S0, P2
cmp S1, P3
cmovge P0, P3
cmovge P3, S1
cmovg S1, P0
cmp P3, S0
cmovle S2, P3
cmovle P3, S0
cmovle S0, S2
cmp S1, P1
