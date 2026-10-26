# n=5 model=out iset=I1 prefix14_class=1188
cmp P1, P2
cmovle S2, P1
cmovle P1, P2
cmovle P2, S2
cmp P3, P0
cmovl S1, P0
cmovge S1, P3
cmovg P3, P0
mov S2, P1
cmp S2, S1
mov S0, P3
cmovge P1, S1
cmovge S1, S2
cmp S0, P2
