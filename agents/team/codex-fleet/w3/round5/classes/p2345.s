# n=5 model=out iset=I1 prefix14_class=2345
cmp P1, P3
cmovle S1, P1
cmovl P1, P3
cmovl P3, S1
mov S2, P2
cmp S2, P0
cmovle S2, P0
cmovge P2, P0
cmp P1, S2
cmovg P0, S2
cmovge S2, P1
cmovle P0, P1
cmp P2, P3
cmovl S2, P3
