# n=5 model=out iset=I1 prefix14_class=9673
mov S2, P3
mov S1, P2
cmp P3, P0
cmovge S2, P0
cmovl P3, P0
cmp S1, P1
cmovle S1, P1
cmovl P1, P2
cmp P3, S1
cmovge P2, S1
cmovge S1, P3
cmovg P3, P2
cmp P1, S2
cmovle P2, S2
