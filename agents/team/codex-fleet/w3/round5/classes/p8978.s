# n=5 model=out iset=I1 prefix14_class=8978
mov S2, P1
cmp P3, P1
cmovg S2, P3
cmovge P3, P1
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
cmovl S1, P0
cmp S2, S1
cmovle S0, S1
cmovl S1, S2
cmovle S2, S0
cmp P2, P3
cmovle P1, P2
