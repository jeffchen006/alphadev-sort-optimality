# n=5 model=out iset=I1 prefix14_class=2709
cmp P0, P1
cmovle S0, P1
cmovge S0, P0
mov S1, S0
cmovle P1, P0
mov P0, P2
cmp P2, P3
cmovle P2, P3
cmovl P3, P0
cmp P2, S1
cmovl S1, P2
cmovle P2, S0
cmp P3, P1
cmovg P2, P1
