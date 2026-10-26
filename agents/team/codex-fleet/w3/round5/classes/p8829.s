# n=5 model=out iset=I1 prefix14_class=8829
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
cmovle S1, P3
cmp P2, P0
cmovl S0, P0
cmovle P0, P2
cmovge S0, P2
cmp S0, S1
mov P3, P1
cmovge S2, S0
cmovg S0, S1
mov P2, S0
cmovg S1, S2
