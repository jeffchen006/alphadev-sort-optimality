# n=5 model=out iset=I1 prefix14_class=4672
mov S1, P2
mov S2, P0
cmp P3, S2
cmovg P0, P3
cmovge P3, S2
cmp P1, S1
cmovle P2, P1
cmovl P1, S1
cmp P1, P0
cmovge S1, P0
mov S2, P2
cmovg P0, P1
cmovge P1, S1
cmp S2, P3
