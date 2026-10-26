# n=5 model=out iset=I1 prefix14_class=10057
mov S0, P0
cmp P0, P3
cmovle P0, P3
mov S1, P1
cmovl P3, S0
cmp P2, S1
cmovl P1, P2
cmovl P2, S1
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
cmovg P0, S0
cmp P1, P3
cmovle S2, P3
