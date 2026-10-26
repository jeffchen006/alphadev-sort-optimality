# n=5 model=out iset=I1 prefix14_class=5750
cmp P2, P3
mov S1, P2
cmovge P2, P3
cmovl S1, P3
mov P3, P0
cmp P3, P1
cmovge P3, P1
cmovge P1, P0
cmp P2, P3
cmovle S2, P3
cmovl P3, P2
mov S0, S1
cmovle P2, S2
cmp S1, P1
