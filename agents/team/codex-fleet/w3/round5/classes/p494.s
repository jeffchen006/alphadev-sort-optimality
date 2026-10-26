# n=5 model=out iset=I1 prefix14_class=494
cmp P3, P0
mov S1, P0
cmovg P0, P3
cmovl S1, P3
mov S0, P2
cmp S0, P1
cmovge P2, P1
cmovge P1, S0
cmp S1, P2
mov S2, P2
cmovle P2, S1
cmovle S1, S2
cmp P0, P1
cmovg S0, P0
