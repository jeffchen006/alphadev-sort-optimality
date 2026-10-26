# n=5 model=out iset=I1 prefix14_class=6008
mov S1, P3
cmp P2, P0
cmovle S0, P2
cmovge S0, P0
cmovle P2, P0
cmp P1, P3
cmovle S1, P1
cmovg P3, P1
mov P1, P3
cmp P2, P3
cmovge P3, P2
cmovg P2, P1
cmp S0, S1
cmovl P1, S1
