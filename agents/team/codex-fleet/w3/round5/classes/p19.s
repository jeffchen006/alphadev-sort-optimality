# n=5 model=out iset=I1 prefix14_class=19
mov S1, P3
cmp P0, S1
cmovle P3, P0
cmovle P0, S1
cmp P2, P1
mov S2, P3
mov S0, P2
cmovge P2, P1
cmovge P1, S0
cmp P3, P2
cmovl S2, P2
cmovge P3, P2
cmp P1, P0
mov P2, P1
