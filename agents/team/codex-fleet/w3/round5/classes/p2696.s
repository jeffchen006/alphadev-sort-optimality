# n=5 model=out iset=I1 prefix14_class=2696
cmp P3, P1
cmovle S2, P3
cmovge S2, P1
cmovge P1, P3
mov S1, P0
cmovl P3, P1
cmp S1, P2
cmovle P0, P2
cmovg S1, P2
cmp P1, P0
cmovl P1, P0
cmovge P3, P0
cmp S1, S2
cmovg P0, S1
