# n=5 model=out iset=I1 prefix14_class=10172
cmp P2, P0
cmovle S1, P2
cmovl P2, P0
cmovle P0, S1
mov S2, P3
cmp P3, P1
cmovg P3, P1
cmovg P1, S2
cmp P2, P1
cmovge S1, P1
cmovge P1, P2
cmovge P2, S1
mov S2, P0
cmp S2, P3
