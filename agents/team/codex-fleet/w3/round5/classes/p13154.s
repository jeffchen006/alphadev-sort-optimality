# n=5 model=out iset=I1 prefix14_class=13154
cmp P1, P3
mov S1, P3
cmovl S1, P1
cmovle P1, P3
mov S2, P2
cmp P2, P0
cmovg P2, P0
cmovle S2, P0
cmp S1, P2
cmovge P0, S1
cmovge S1, P2
cmovge P2, P0
cmp S2, P1
cmovg S0, S2
