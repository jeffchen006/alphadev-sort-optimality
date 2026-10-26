# n=5 model=out iset=I1 prefix14_class=9082
cmp P2, P0
cmovle S1, P2
cmovle P2, P0
cmovle P0, S1
cmp P3, P1
mov S0, P3
cmovle P3, P1
cmovge S0, P1
cmp P0, S0
mov S2, P0
cmovge P0, S0
cmovl S2, S0
cmp P3, P2
cmovge S1, P2
