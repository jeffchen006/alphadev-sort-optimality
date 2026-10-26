# n=5 model=out iset=I1 prefix14_class=13792
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
cmovge P0, S1
cmp P1, P3
mov S0, P3
cmovl S0, P1
cmovle P1, P3
mov P3, P1
cmp P0, P1
cmovge P3, P0
cmovle P1, P0
cmp P2, S0
cmovle S1, S0
