# n=5 model=out iset=I1 prefix14_class=3184
cmp P2, P1
cmovge S2, P1
cmovle S2, P2
cmovge P1, P2
cmp P3, P0
mov S1, P3
cmovge P3, P0
cmovg P0, S1
cmp S2, P3
cmovge P2, P3
cmovl P2, S2
cmovle S2, P3
cmp P1, P0
cmovg S1, P0
