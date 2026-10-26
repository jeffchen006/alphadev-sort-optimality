# n=5 model=out iset=I1 prefix14_class=10226
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
mov S1, P3
cmovle P2, S0
cmp P1, S1
cmovge P3, P1
cmovg P1, S1
mov S1, P0
cmp P3, S1
cmovge S1, P3
cmovle P0, P3
cmp P2, P1
cmovle S0, P2
