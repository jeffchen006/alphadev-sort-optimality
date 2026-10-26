# n=5 model=out iset=I1 prefix14_class=9708
mov S0, P2
mov S1, P0
cmp P3, S0
cmovge S0, P3
cmovge P3, P2
cmp P1, S1
cmovge P0, P1
cmovge P1, S1
cmp P0, S0
cmovle S1, S0
cmovle S0, P0
cmovl P0, S1
cmp P1, P3
cmovle P0, P1
