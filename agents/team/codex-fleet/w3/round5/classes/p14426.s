# n=5 model=out iset=I1 prefix14_class=14426
mov S1, P3
mov S2, P2
cmp P2, P0
cmovge S2, P0
cmovle P2, P0
cmp P1, P3
cmovle S1, P1
cmovge P3, P1
mov S0, S1
cmp S0, S2
cmovl S1, P3
cmovge S0, S2
cmovg S2, S1
cmp P2, P3
