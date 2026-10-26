# n=5 model=out iset=I1 prefix14_class=10875
cmp P1, P3
cmovle S1, P3
cmovl P3, P1
cmovle P1, S1
cmp P2, P0
mov S0, P0
cmovge P0, P2
cmovle S0, P2
cmp P0, P1
mov S2, P1
cmovge S2, P0
cmovle P1, P0
cmp P3, S0
cmovl P0, S0
