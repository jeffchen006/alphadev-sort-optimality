# n=5 model=out iset=I1 prefix14_class=1712
cmp P3, P1
cmovl S2, P1
cmovl P1, P3
cmovge S2, P3
cmp P0, P2
cmovle P3, P2
cmovle P2, P0
cmovle P0, P3
mov S0, P2
cmp P1, P2
cmovge P2, P1
cmovle S0, P1
mov S1, P2
cmp P0, S2
