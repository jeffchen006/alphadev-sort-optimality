# n=5 model=out iset=I1 prefix14_class=14147
cmp P0, P1
cmovl S1, P1
cmovle P1, P0
cmovl P0, S1
mov S2, P2
cmp P3, S2
cmovge S2, P3
cmovge P3, P2
mov P2, S2
cmp S2, P0
cmovg P2, P0
cmovge P0, S2
cmp P3, P1
cmovle S1, P3
