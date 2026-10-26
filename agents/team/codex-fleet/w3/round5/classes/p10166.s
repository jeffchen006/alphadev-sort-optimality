# n=5 model=out iset=I1 prefix14_class=10166
cmp P3, P0
cmovle S2, P3
cmovl P3, P0
cmovl P0, S2
mov S1, P2
cmp S1, P1
cmovg P2, P1
cmovge P1, S1
mov S0, P0
cmp P3, P1
cmovle S2, P1
cmovl P1, P3
cmovle P3, S2
mov P3, P1
