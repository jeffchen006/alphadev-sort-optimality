# n=5 model=out iset=I1 prefix14_class=5689
mov S2, P1
mov S0, P2
cmp P1, P0
cmovg S2, P0
cmovge P0, P1
cmp P2, P3
mov S1, S2
cmovge S0, P3
cmovge P3, P2
cmp S0, S2
cmovle S1, S0
cmovl S0, S2
cmp P3, P0
cmovle S2, P0
