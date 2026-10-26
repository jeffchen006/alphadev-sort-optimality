# n=5 model=out iset=I1 prefix14_class=6037
cmp P0, P3
mov S2, P2
cmovle S1, P3
cmovl P3, P0
cmovge S1, P0
cmovl P0, S1
cmp P1, P2
cmovl S2, P1
cmovle P1, P2
cmp P1, S1
cmovle S1, P1
cmovge P0, P1
cmp S2, P3
mov P0, S1
