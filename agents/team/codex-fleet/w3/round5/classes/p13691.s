# n=5 model=out iset=I1 prefix14_class=13691
mov S2, P3
mov S1, P0
cmp S1, P1
cmovge P0, P1
cmovle S1, P1
cmp S2, P2
cmovl P3, P2
cmovg S2, P2
cmp S2, P0
cmovge S0, S2
cmovge S2, P0
cmovge P0, S0
mov S2, P3
cmp S1, P3
