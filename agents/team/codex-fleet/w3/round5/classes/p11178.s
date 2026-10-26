# n=5 model=out iset=I1 prefix14_class=11178
cmp P1, P2
mov S0, P2
cmovg P2, P1
cmovg P1, S0
mov S2, P3
mov S1, P2
cmp P3, P0
cmovle P3, P0
cmovle P0, S2
cmp S1, P3
cmovge P2, P3
cmovle S1, P3
cmp P1, P0
cmovl P3, P1
