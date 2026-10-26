# n=5 model=out iset=I1 prefix14_class=5237
cmp P0, P2
cmovle S0, P2
cmovg S0, P0
cmovge P0, P2
cmovge P2, S0
mov S1, P1
cmp P3, P1
cmovl S1, P3
cmovle P3, P1
cmp S1, P0
cmovg S2, S1
cmovg S1, P0
cmovg P0, S2
cmp P3, S0
