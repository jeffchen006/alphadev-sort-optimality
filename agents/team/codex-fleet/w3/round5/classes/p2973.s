# n=5 model=out iset=I1 prefix14_class=2973
cmp P0, P1
mov S1, P3
cmovle S2, P1
cmovl P1, P0
cmovge S2, P0
cmp S1, P2
cmovg P3, P2
cmovge P2, S1
cmp P2, S2
cmovl P0, S2
cmovle S2, P2
cmovl P2, P0
cmp P1, P3
mov P2, P3
