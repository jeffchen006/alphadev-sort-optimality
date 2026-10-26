# n=5 model=out iset=I1 prefix14_class=6708
cmp P3, P1
cmovge S1, P1
cmovle S1, P3
cmovl P3, P1
cmp P0, P2
cmovge P1, P0
cmovl P1, P2
cmovle P2, P0
cmp P1, P3
cmovge S2, P1
cmovl S2, P3
cmovl P3, P1
cmp S1, P2
cmovge S2, P2
