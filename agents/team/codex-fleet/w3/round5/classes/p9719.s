# n=5 model=out iset=I1 prefix14_class=9719
cmp P1, P2
cmovge S2, P2
cmovge P2, P1
mov S0, P2
cmovg P1, S2
cmp P3, P0
cmovle S1, P0
cmovge S1, P3
cmovl P0, P3
cmp S1, S0
cmovge S0, S1
cmovle P2, S1
cmp P1, P0
cmovle P3, P1
