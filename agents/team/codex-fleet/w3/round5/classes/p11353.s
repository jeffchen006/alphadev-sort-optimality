# n=5 model=out iset=I1 prefix14_class=11353
mov S0, P1
cmp P0, P1
cmovge P1, P0
cmovge P0, S0
mov S1, P3
cmp P2, S1
cmovl P3, P2
cmovge S1, P2
cmp P1, S1
cmovle S0, P1
cmovle P1, S1
cmovl S1, S0
cmp P3, P0
cmovle S2, P0
