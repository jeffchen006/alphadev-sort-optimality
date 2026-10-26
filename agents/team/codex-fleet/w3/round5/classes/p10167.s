# n=5 model=out iset=I1 prefix14_class=10167
cmp P3, P0
mov S1, P3
cmovl P3, P0
mov S2, P2
cmovl P0, S1
cmp S2, P1
mov S0, P0
cmovg P2, P1
cmovge P1, S2
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
cmovl P3, S1
mov P3, P1
