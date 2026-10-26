# n=5 model=out iset=I1 prefix14_class=13812
mov S1, P3
mov S2, P1
cmp S1, P2
cmovg P3, P2
cmovl S1, P2
cmp P0, S2
cmovge P1, P0
cmovle S2, P0
cmp S1, P1
cmovge S0, P1
cmovg P1, S1
cmovg S1, S0
cmp S2, P3
cmovle S0, P3
