# n=5 model=out iset=I1 prefix14_class=7328
cmp P3, P0
mov S2, P0
cmovle S2, P3
cmovg P0, P3
cmp P2, P1
cmovle S1, P2
cmovg S1, P1
cmovle P2, P1
mov S0, S2
cmp S1, S0
cmovl S2, S1
cmovg S0, S1
cmp P2, P0
cmovge S2, P2
