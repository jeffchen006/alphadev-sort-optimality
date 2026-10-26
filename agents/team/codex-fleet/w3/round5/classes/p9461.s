# n=5 model=out iset=I1 prefix14_class=9461
cmp P1, P0
cmovge S0, P1
cmovle S0, P0
mov S1, P3
cmovl P0, P1
cmp P3, P2
cmovg P3, P2
cmovge P2, S1
cmp P0, P3
cmovle P1, P3
cmovle P3, P0
cmovl P0, P1
cmp S0, P2
cmovle P3, S0
