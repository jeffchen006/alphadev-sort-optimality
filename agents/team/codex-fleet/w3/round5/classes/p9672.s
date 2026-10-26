# n=5 model=out iset=I1 prefix14_class=9672
mov S2, P3
mov S1, P0
cmp P3, P2
cmovge S2, P2
cmovl P3, P2
cmp S1, P1
cmovle S1, P1
cmovl P1, P0
cmp P3, S1
cmovge P0, S1
cmovge S1, P3
cmovg P3, P0
cmp P1, S2
cmovle P0, S2
