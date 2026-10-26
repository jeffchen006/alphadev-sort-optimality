# n=5 model=out iset=I1 prefix14_class=4259
mov S1, P1
cmp P3, S1
mov S0, P2
cmovl S1, P3
cmovg P1, P3
cmp P0, S0
cmovge S0, P0
cmovge P0, P2
cmp S1, P0
cmovle S2, P0
cmovg S2, S1
cmovle P0, S1
cmp P1, S0
cmovle P2, S0
