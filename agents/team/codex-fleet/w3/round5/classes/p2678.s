# n=5 model=out iset=I1 prefix14_class=2678
mov S1, P2
cmp P3, S1
cmovge S1, P3
cmovl P2, P3
cmp P1, P0
cmovge P3, P1
cmovle P3, P0
cmovge P1, P0
cmovg P0, P3
cmp S1, P0
cmovl P3, S1
cmovl S1, P0
cmp P2, P1
cmovle S1, P2
