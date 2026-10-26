# n=5 model=out iset=I1 prefix14_class=5914
cmp P3, P0
cmovge S2, P3
mov S1, P1
cmovle S2, P0
cmovge P3, P0
cmp P2, S1
cmovg S1, P2
cmovge P2, P1
cmp S2, S1
cmovle S0, S2
cmovl S2, S1
cmovl S1, S0
mov S2, P3
cmp P3, P2
