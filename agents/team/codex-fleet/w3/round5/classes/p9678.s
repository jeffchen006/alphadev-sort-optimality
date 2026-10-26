# n=5 model=out iset=I1 prefix14_class=9678
mov S2, P0
cmp P1, P3
mov S1, P1
cmovle S1, P3
cmovge P1, P3
mov S0, S1
cmp P2, P0
cmovl S2, P2
cmovl P2, P0
cmp S0, P2
cmovle S1, P2
cmovle P2, S0
cmp P1, S2
cmovge S0, S2
