# n=5 model=out iset=I1 prefix14_class=1671
cmp P1, P0
mov S0, P3
cmovle S1, P0
cmovl P0, P1
cmovle P1, S1
cmp P3, P2
cmovge P3, P2
cmovg P2, S0
cmp P0, P3
cmovge S0, P0
cmovle S0, P3
cmovg P0, P3
mov P0, P2
cmp P2, P1
