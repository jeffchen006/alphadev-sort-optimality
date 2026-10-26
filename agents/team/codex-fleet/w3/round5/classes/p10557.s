# n=5 model=out iset=I1 prefix14_class=10557
mov S0, P3
cmp P1, S0
cmovl S0, P1
cmovge P3, P1
mov S1, P2
cmp P0, P2
cmovge P2, P0
cmovle S1, P0
cmp P2, P3
mov S2, P2
cmovle P2, P3
cmovle P3, S2
cmp S0, S1
cmovge P0, S0
