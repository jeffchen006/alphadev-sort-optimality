# n=5 model=out iset=I1 prefix14_class=3840
mov S2, P1
cmp S2, P2
cmovg P1, P2
cmovge P2, S2
cmp P0, P3
cmovge S2, P0
cmovle S2, P3
cmovl P3, P0
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
cmp P2, S2
cmovle S1, S2
