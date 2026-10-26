# n=5 model=out iset=I1 prefix14_class=11106
cmp P1, P0
cmovge S0, P0
cmovge P0, P1
cmovl S0, P1
cmp P3, P2
cmovle P1, P3
cmovle P3, P2
cmovle P2, P1
mov S2, P2
cmp P0, P3
cmovle S1, P3
cmovl P3, P0
cmovle P0, S1
cmp P2, S0
