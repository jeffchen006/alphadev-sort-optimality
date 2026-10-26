# n=5 model=out iset=I1 prefix14_class=2647
mov S1, P1
cmp P1, P3
cmovl S1, P3
cmovge P1, P3
mov S2, P0
cmp P2, P0
cmovl S2, P2
cmovge P0, P2
cmp P0, S1
mov P3, P0
cmovle P0, S1
mov P0, S2
cmovge P3, S1
cmp P1, S2
