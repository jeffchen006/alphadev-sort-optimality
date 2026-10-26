# n=5 model=out iset=I1 prefix14_class=6156
cmp P3, P0
mov S2, P1
cmovge S0, P3
cmovle S0, P0
cmovge P3, P0
cmp S2, P2
cmovge P1, P2
cmovge P2, S2
cmp S0, P2
mov S1, S0
cmovl S1, P2
cmovg S0, P2
mov P0, S0
mov S1, P1
