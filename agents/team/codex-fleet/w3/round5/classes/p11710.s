# n=5 model=out iset=I1 prefix14_class=11710
mov S0, P0
cmp P0, P2
cmovle S0, P2
cmovge P0, P2
cmovge P2, S0
cmp P1, P3
cmovle S2, P1
cmovl P1, P3
cmovle P3, S2
cmp P1, P2
cmovl P2, P1
cmovge S0, P1
cmp P3, P0
cmovle P1, P0
