# n=5 model=out iset=I1 prefix14_class=608
cmp P2, P1
cmovl S2, P1
cmovge S2, P2
cmovge P2, P1
mov S0, P3
cmp S0, P0
cmovg S0, P0
cmovge P0, P3
mov P3, S2
mov S1, P2
cmp P0, P3
cmovge P3, P0
cmovle S2, P0
cmp S0, S1
