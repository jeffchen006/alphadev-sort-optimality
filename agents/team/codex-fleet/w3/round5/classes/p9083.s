# n=5 model=out iset=I1 prefix14_class=9083
cmp P2, P0
mov S1, P2
cmovle P2, P0
cmovle P0, S1
mov S2, P1
cmp P1, P3
cmovle P1, P3
cmovge S2, P3
mov S0, P0
cmp P0, S2
cmovge P0, S2
cmovl S0, S2
cmp P2, P1
cmovle S1, P2
