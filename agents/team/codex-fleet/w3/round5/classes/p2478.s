# n=5 model=out iset=I1 prefix14_class=2478
cmp P1, P2
cmovg S2, P1
cmovg P1, P2
cmovle S2, P2
mov S1, P3
cmp P0, P3
cmovg S1, P0
mov S0, S2
cmovge P0, P3
cmp S2, S1
cmovle S0, S1
cmovl S1, S2
cmp P0, P1
cmovle P2, P0
