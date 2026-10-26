# n=5 model=out iset=I1 prefix14_class=2091
cmp P3, P0
mov S0, P0
cmovg P0, P3
cmovle S0, P3
mov P3, P1
cmp P1, P2
cmovle P3, P2
cmovge P1, P2
cmp P0, P3
cmovg S2, P0
cmovle S2, P3
cmovg P0, P3
cmp S0, P1
cmovl S1, S0
