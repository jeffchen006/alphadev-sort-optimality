# n=5 model=out iset=I1 prefix14_class=11009
cmp P2, P0
cmovge S2, P0
cmovge P0, P2
cmovge P2, S2
cmp P3, P1
cmovle S1, P1
cmovge S1, P3
cmovl P1, P3
cmp S1, P0
mov P3, S1
cmovle P3, P0
cmovle P0, S1
cmp P2, P1
cmovle S1, P1
