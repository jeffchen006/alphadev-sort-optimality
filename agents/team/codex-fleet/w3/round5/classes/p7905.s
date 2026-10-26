# n=5 model=out iset=I1 prefix14_class=7905
cmp P1, P2
mov S2, P1
cmovle P1, P2
cmovl P2, S2
mov S1, P3
cmp P0, S1
cmovle S1, P0
cmovg P3, P0
mov P0, S1
cmp P2, S1
cmovge S1, P2
cmovle P0, P2
cmp P3, P1
cmovl S0, P3
