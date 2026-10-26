# n=5 model=out iset=I1 prefix14_class=1391
mov S0, P0
mov S1, P2
cmp P1, P2
cmovle S1, P1
cmovge P2, P1
mov S2, P2
cmp P0, P3
cmovge P0, P3
cmovge P3, S0
cmp P3, S2
cmovl S2, P3
cmovle P3, P2
mov P3, P0
cmovle P2, S2
