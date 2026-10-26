# n=5 model=out iset=I1 prefix14_class=10795
mov S2, P2
cmp P3, S2
cmovle S2, P3
mov S1, P0
cmovge P2, P3
cmp P0, P1
cmovle P0, P1
cmovle P1, S1
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
cmovl P2, S0
mov P0, P1
cmp S2, P1
