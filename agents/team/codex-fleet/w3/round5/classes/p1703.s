# n=5 model=out iset=I1 prefix14_class=1703
cmp P3, P1
cmovl S2, P1
cmovge S2, P3
cmovle P1, P3
cmp P2, P0
cmovle S0, P0
cmovle P0, P2
mov P3, P0
cmovl P2, S0
cmp P1, P0
cmovg P0, P1
cmovle P3, P1
cmp P2, S2
cmovle P3, S2
