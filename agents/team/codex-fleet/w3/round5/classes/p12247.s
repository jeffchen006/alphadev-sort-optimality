# n=5 model=out iset=I1 prefix14_class=12247
cmp P2, P0
mov S2, P2
cmovle P2, P0
cmovg S2, P0
mov S0, P3
cmp P1, P3
cmovge P3, P1
cmovle S0, P1
cmp S0, S2
cmovle S1, S0
cmovl S0, S2
cmovl S2, S1
mov S2, P3
cmp P2, P3
