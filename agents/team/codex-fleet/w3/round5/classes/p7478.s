# n=5 model=out iset=I1 prefix14_class=7478
cmp P1, P3
cmovle S1, P1
cmovge S1, P3
cmovle P1, P3
cmp P0, P2
cmovg P3, P2
cmovle P3, P0
cmovle P0, P2
cmp P3, S1
cmovl S2, P3
cmovle P3, S1
cmovl S1, S2
cmp P0, P1
mov P2, P1
