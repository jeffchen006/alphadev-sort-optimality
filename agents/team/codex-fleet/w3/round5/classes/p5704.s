# n=5 model=out iset=I1 prefix14_class=5704
mov S1, P3
mov S2, P0
cmp P0, P2
cmovge P0, P2
cmovg P2, S2
cmp P1, P3
cmovge S1, P1
cmovl P3, P1
mov S2, P0
cmp P3, P0
cmovle P0, P3
cmovl P3, S2
cmp S1, P2
cmovle S0, S1
