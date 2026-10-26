# n=5 model=out iset=I1 prefix14_class=3031
mov S1, P1
cmp P3, P2
mov S2, P2
cmovl P2, P3
cmovl P3, S2
cmp P0, S1
cmovle S1, P0
cmovge P1, P0
mov P0, P2
cmp P0, S1
cmovle P2, S1
cmovle S1, P0
mov S0, P2
cmp P1, P3
