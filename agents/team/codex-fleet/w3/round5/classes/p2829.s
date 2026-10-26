# n=5 model=out iset=I1 prefix14_class=2829
mov S1, P1
cmp P1, P0
cmovle S1, P0
cmovg P1, P0
cmp P2, P3
mov S0, S1
mov P0, P3
cmovge P3, P2
cmovle P0, P2
cmp S1, P3
cmovle S1, P3
cmovl P3, S0
cmp P1, P0
cmovge S2, P1
