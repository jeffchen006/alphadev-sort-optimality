# n=5 model=out iset=I1 prefix14_class=2249
cmp P1, P2
cmovg S2, P1
mov S0, P0
cmovle S2, P2
cmovge P1, P2
cmp P3, S0
cmovge S0, P3
mov S1, S0
cmovge P3, P0
cmp S0, S2
cmovle S0, S2
cmovl S2, S1
cmp P3, P1
cmovle S1, P3
