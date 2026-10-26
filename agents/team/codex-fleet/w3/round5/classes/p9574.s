# n=5 model=out iset=I1 prefix14_class=9574
cmp P0, P1
cmovle S0, P0
cmovle P0, P1
mov S2, P3
cmovle P1, S0
cmp P2, P3
cmovge S2, P2
cmovge P2, P3
cmp P0, S2
cmovl P3, S2
cmovle S2, P0
cmovge P3, P0
cmp P2, P1
cmovge P0, P2
