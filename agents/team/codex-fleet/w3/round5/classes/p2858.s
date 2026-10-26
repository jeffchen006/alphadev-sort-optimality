# n=5 model=out iset=I1 prefix14_class=2858
cmp P1, P3
cmovge S2, P3
cmovl S2, P1
cmovge P3, P1
cmp P2, P0
mov S0, P3
cmovle S1, P2
cmovle P2, P0
cmovg S1, P0
cmp P2, S0
cmovge P3, P2
cmovg P2, S0
cmp S1, S2
mov P3, S1
