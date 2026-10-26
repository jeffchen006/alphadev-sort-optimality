# n=5 model=out iset=I1 prefix14_class=11796
cmp P1, P3
cmovle S1, P3
mov S2, P2
cmovl P3, P1
cmovge S1, P1
cmp P0, P2
cmovl S2, P0
cmovle P0, P2
cmp S1, P0
cmovge P2, P0
cmovge P0, S1
cmovg S1, P2
cmp S2, P3
cmovl P1, P3
