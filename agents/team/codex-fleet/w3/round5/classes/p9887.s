# n=5 model=out iset=I1 prefix14_class=9887
mov S0, P1
cmp P1, P0
cmovge P1, P0
cmovge P0, S0
cmp P2, P3
mov S2, P2
cmovle S2, P3
cmovl P3, P2
mov S0, P3
cmp P0, S2
cmovle P2, S2
cmovle S2, P0
cmovle P0, P2
cmp P3, P1
