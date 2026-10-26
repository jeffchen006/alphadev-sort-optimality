# n=5 model=out iset=I1 prefix14_class=10345
cmp P0, P3
cmovl S1, P3
cmovle P3, P0
cmovge S1, P0
mov P0, P2
cmp P1, P2
cmovle P2, P1
cmovge P0, P1
cmp P0, S1
mov S2, P0
cmovge S2, S1
cmovg S1, P0
cmp P3, P2
cmovge S0, P2
