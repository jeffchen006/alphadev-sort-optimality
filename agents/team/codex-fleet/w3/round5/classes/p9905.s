# n=5 model=out iset=I1 prefix14_class=9905
mov S2, P3
cmp P1, P0
cmovge S0, P1
cmovge P1, P0
cmovge P0, S0
cmp P3, P2
cmovl P3, P2
cmovle P2, S2
cmp P3, P0
cmovge S2, P0
cmovl S2, P3
cmovle P3, P0
cmp P1, P2
cmovle S0, P1
