# n=5 model=out iset=I1 prefix14_class=5686
cmp P1, P2
cmovge S1, P2
cmovl S1, P1
cmovge P2, P1
cmp P0, P3
cmovle S0, P0
cmovg S0, P3
cmovge P3, P0
mov S2, S1
cmp S0, S2
cmovle S1, S0
cmovle S0, S2
cmp P2, P3
cmovge S2, P2
