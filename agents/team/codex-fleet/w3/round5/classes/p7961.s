# n=5 model=out iset=I1 prefix14_class=7961
mov S2, P0
cmp P1, S2
cmovge P0, P1
cmovg P1, S2
cmp P2, P3
cmovle S2, P3
cmovge S2, P2
cmovg P2, P3
cmovl P3, P2
cmp P2, P1
cmovg P2, P1
cmovle P3, P1
cmp P0, S2
cmovge S1, S2
