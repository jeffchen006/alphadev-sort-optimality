# n=5 model=out iset=I1 prefix14_class=2098
cmp P3, P0
mov S2, P1
cmovge S0, P0
cmovge P0, P3
cmovl S0, P3
cmp S2, P2
cmovg S2, P2
cmovle P1, P2
cmp P0, P1
cmovge S1, P0
cmovle S1, P1
cmovg P0, P1
cmp S2, S0
mov S1, S2
