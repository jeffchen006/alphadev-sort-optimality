# n=5 model=out iset=I1 prefix14_class=824
mov S1, P3
cmp P3, P2
cmovge P3, P2
cmovl S1, P2
mov S2, S1
mov P2, P0
cmp P1, P0
cmovge P2, P1
cmovle P0, P1
cmp P2, S1
cmovl S2, P2
cmovg S1, P2
cmp P3, P0
cmovge P1, P3
