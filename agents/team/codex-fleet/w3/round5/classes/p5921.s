# n=5 model=out iset=I1 prefix14_class=5921
cmp P3, P0
cmovge S2, P3
cmovle S2, P0
mov S1, P2
cmovg P3, P0
cmp P1, S1
cmovg S1, P1
cmovge P1, P2
cmp S1, S2
cmovl S0, S1
cmovl S1, S2
cmovl S2, S0
mov P2, S2
cmp P1, P3
