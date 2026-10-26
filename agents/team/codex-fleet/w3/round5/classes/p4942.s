# n=5 model=out iset=I1 prefix14_class=4942
cmp P3, P0
cmovle S1, P0
mov S2, P2
cmovge S1, P3
cmovg P3, P0
cmp S2, P1
cmovl P2, P1
mov P0, P3
cmovl P1, S2
cmp P3, P1
cmovg P3, P1
cmovge P1, P0
cmp S1, P2
cmovle S2, P2
