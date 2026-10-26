# n=5 model=out iset=I1 prefix14_class=4891
mov S1, P1
mov S2, P2
cmp P0, S2
cmovl S2, P0
cmovle P0, P2
cmp P3, P1
cmovl S1, P3
cmovle P3, P1
mov P2, S1
cmp P2, S2
cmovge P2, S2
cmovle S1, S2
cmp P3, P0
cmovle S0, P0
