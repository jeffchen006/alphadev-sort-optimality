# n=5 model=out iset=I1 prefix14_class=12316
cmp P0, P1
mov S1, P2
cmovge S0, P0
cmovg P0, P1
cmovge P1, S0
cmp S1, P3
cmovl P2, P3
cmovle P3, S1
cmp P3, P0
mov S1, P0
cmovle S1, P3
cmovg P0, P3
cmp P1, P2
cmovge S0, P2
