# n=5 model=out iset=I1 prefix14_class=10510
mov S0, P0
cmp P3, P1
cmovle S2, P3
cmovge S2, P1
cmovge P1, P3
cmp P0, P2
cmovge P0, P2
cmovle S0, P2
cmp P1, S0
cmovle P2, P1
cmovl P1, S0
cmovle S0, P2
mov P1, P0
cmp P0, S2
