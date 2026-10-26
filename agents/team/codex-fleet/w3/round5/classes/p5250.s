# n=5 model=out iset=I1 prefix14_class=5250
cmp P0, P1
mov S0, P0
cmovge P0, P1
cmovge P1, S0
cmp P2, P3
cmovl S1, P3
cmovle P3, P2
cmovl P2, S1
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
cmovl S0, P0
cmp P2, P1
cmovle S2, P1
