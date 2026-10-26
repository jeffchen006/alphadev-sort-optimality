# n=5 model=out iset=I1 prefix14_class=5238
cmp P3, P2
cmovle S0, P2
cmovg S0, P3
cmovge P3, P2
cmovge P2, S0
mov S1, P1
cmp P0, P1
cmovl S1, P0
cmovle P0, P1
cmp S1, P3
cmovg S2, S1
cmovg S1, P3
cmovg P3, S2
cmp P0, S0
