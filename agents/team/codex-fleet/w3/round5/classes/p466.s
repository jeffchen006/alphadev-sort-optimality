# n=5 model=out iset=I1 prefix14_class=466
cmp P3, P2
cmovge S0, P3
mov S1, P1
cmovl S0, P2
cmovl P2, P3
cmp P1, P0
cmovg P1, P0
cmovge P0, S1
mov S1, P2
cmp P1, P2
cmovle P2, P1
cmovle P1, S1
mov S2, S0
mov P2, P1
