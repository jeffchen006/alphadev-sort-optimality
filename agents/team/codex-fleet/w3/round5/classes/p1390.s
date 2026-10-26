# n=5 model=out iset=I1 prefix14_class=1390
mov S0, P2
mov S1, P0
cmp P1, P0
cmovle S1, P1
cmovge P0, P1
mov S2, P0
cmp P2, P3
cmovge P2, P3
cmovge P3, S0
cmp P3, S2
cmovl S2, P3
cmovle P3, P0
mov P3, P2
cmovle P0, S2
