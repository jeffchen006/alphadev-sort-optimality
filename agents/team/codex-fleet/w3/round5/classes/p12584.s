# n=5 model=out iset=I1 prefix14_class=12584
cmp P3, P1
cmovge S2, P3
cmovge P3, P1
cmovle S2, P1
mov S0, P3
cmp P2, P0
cmovle P1, P0
cmovl P0, P2
cmovle P2, P1
cmp P0, S0
cmovle P3, P0
mov P3, S2
cmovle P0, S0
cmp P3, P2
