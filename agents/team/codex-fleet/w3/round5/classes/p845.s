# n=5 model=out iset=I1 prefix14_class=845
cmp P0, P1
cmovl S1, P1
mov S2, P3
cmovge S1, P0
cmovge P0, P1
cmp S2, P2
cmovg S2, P2
cmovg P2, P3
cmp P2, S1
mov P1, S1
cmovg S1, P2
cmovge P2, P1
cmp P0, S2
cmovle S1, S2
