# n=5 model=out iset=I1 prefix14_class=3414
mov S1, P3
cmp P1, P3
cmovge P3, P1
cmovl S1, P1
mov P1, P0
mov S0, S1
cmp P0, P2
cmovge P0, P2
cmovle P1, P2
cmp P0, S0
cmovg S1, P0
mov S2, P3
mov P2, S1
cmovl S0, P0
