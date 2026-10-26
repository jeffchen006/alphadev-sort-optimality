# n=5 model=out iset=I1 prefix14_class=1874
cmp P2, P3
mov S2, P3
mov S1, P1
cmovle P3, P2
cmovl P2, S2
cmp P0, P1
cmovge P1, P0
cmovle S1, P0
mov S2, P2
cmp P1, S2
cmovl P2, P1
cmovl P1, S2
cmp P3, S1
cmovle S0, P3
