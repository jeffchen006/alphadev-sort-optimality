# n=5 model=out iset=I1 prefix14_class=11408
cmp P2, P3
cmovle S2, P3
cmovle P3, P2
cmovle P2, S2
cmp P0, P1
cmovge S0, P0
cmovl S0, P1
cmovge P0, P1
cmp P3, P0
mov S1, S0
cmovle P1, P0
cmovle P0, P3
cmovge P1, P3
mov P0, P1
