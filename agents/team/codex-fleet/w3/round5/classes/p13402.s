# n=5 model=out iset=I1 prefix14_class=13402
cmp P0, P2
cmovge S2, P0
mov S1, P3
cmovge P0, P2
cmovg P2, S2
cmp P1, P3
cmovle P3, P1
cmovge S1, P1
cmovge P1, P3
cmp P0, P3
cmovle P3, P0
cmovl P0, P1
cmp P2, S1
mov P3, P2
