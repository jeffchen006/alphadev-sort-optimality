# n=5 model=out iset=I1 prefix14_class=4913
cmp P1, P0
cmovge S0, P1
cmovle S0, P0
cmovl P0, P1
mov S1, P2
cmp P3, P2
mov S2, P0
cmovle P2, P3
cmovle P3, S1
cmp P0, P2
cmovl S2, P2
cmovge P0, P2
cmp P3, S0
cmovge P2, P3
