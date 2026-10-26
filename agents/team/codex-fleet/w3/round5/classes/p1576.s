# n=5 model=out iset=I1 prefix14_class=1576
cmp P0, P3
mov S0, P3
cmovle S0, P0
cmovge P3, P0
mov S2, S0
cmp P2, P1
mov S1, P1
cmovle P1, P2
cmovg S1, P2
cmp P1, S0
cmovge S0, P1
mov P2, S0
cmovl S2, P1
mov P0, P3
