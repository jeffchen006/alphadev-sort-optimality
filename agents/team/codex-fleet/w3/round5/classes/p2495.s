# n=5 model=out iset=I1 prefix14_class=2495
mov S2, P0
cmp P2, P0
cmovle P0, P2
mov S1, P3
cmovle P2, S2
cmp P1, P3
mov S0, P2
cmovge S1, P1
cmovge P1, P3
cmp P2, S1
cmovl S0, S1
mov S0, P1
cmovle S1, P2
mov P3, S1
