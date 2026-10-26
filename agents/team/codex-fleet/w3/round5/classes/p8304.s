# n=5 model=out iset=I1 prefix14_class=8304
cmp P0, P2
cmovle S2, P0
cmovl P0, P2
cmovle P2, S2
mov S2, P2
mov S0, P1
cmp P3, P1
cmovl P1, P3
cmovg S0, P3
cmp P2, P1
cmovle S2, P1
cmovle P1, P2
cmp P0, S0
cmovge P2, S0
