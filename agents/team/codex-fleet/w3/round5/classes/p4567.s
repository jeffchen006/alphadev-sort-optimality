# n=5 model=out iset=I1 prefix14_class=4567
mov S0, P2
cmp P1, P2
cmovl S0, P1
cmovge P2, P1
cmp P0, P3
cmovge S1, P0
cmovge P0, P3
cmovle S1, P3
cmp P2, S1
mov P3, S1
cmovge S1, P2
cmovle P3, P2
cmp S0, P0
mov P1, P3
