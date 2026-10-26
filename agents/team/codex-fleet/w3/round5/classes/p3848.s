# n=5 model=out iset=I1 prefix14_class=3848
mov S1, P3
cmp S1, P2
cmovge P3, P2
cmovg P2, S1
cmp P0, P1
cmovge S0, P0
cmovle S0, P1
cmovle P1, P0
mov S1, P3
cmp P3, P1
cmovle P3, P1
cmovl P1, S1
cmp P2, S0
cmovg P1, S0
