# n=5 model=out iset=I1 prefix14_class=1929
cmp P1, P3
cmovle S1, P3
cmovle P3, P1
cmovle P1, S1
cmp P0, P2
cmovl S2, P2
cmovle P2, P0
cmovl P0, S2
cmp P0, P1
cmovge S0, P1
cmovle S0, P0
cmovg P1, P0
cmp P2, P3
mov P1, P2
