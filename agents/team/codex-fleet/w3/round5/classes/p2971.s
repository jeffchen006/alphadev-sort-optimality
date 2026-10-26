# n=5 model=out iset=I1 prefix14_class=2971
cmp P0, P1
mov S1, P2
cmovle S2, P1
cmovge S2, P0
cmovle P1, P0
cmp S1, P3
cmovge P2, P3
cmovg P3, S1
cmp P3, S2
cmovle S1, S2
cmovle S2, P3
cmovl P3, S1
cmp P1, P2
mov P3, P2
