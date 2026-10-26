# n=5 model=out iset=I1 prefix14_class=5812
mov S1, P1
mov S0, P3
cmp S0, P0
cmovle S0, P0
cmovge P3, P0
cmp S1, P2
cmovle S1, P2
cmovle P2, P1
mov P0, P2
cmp P0, P3
cmovge P2, P3
cmovl P0, P3
cmp S1, S0
cmovge P2, S0
