# n=5 model=out iset=I1 prefix14_class=8685
mov S2, P2
cmp P1, P2
cmovle P2, P1
cmovge S2, P1
mov S1, P0
cmp S1, P3
cmovge P0, P3
cmovle S1, P3
cmp S1, S2
cmovle S0, S2
cmovge S0, S1
cmovl S2, S1
cmp P2, P0
cmovge P3, P2
