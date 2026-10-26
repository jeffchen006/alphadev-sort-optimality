# n=5 model=out iset=I1 prefix14_class=14126
cmp P0, P2
mov S0, P3
cmovge S2, P0
cmovge P0, P2
cmovg P2, S2
cmp P1, P3
cmovl S0, P1
cmovg P3, P1
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
mov P1, S0
cmovl P2, S1
cmp P0, P1
