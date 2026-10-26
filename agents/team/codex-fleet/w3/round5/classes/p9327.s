# n=5 model=out iset=I1 prefix14_class=9327
mov S2, P1
cmp P1, P3
cmovle P1, P3
cmovl P3, S2
cmp P0, P2
mov S2, P0
cmovl P0, P2
cmovge S2, P2
cmp P3, S2
cmovge P2, S2
cmovl P2, P3
cmovge S2, P3
cmp P1, P0
cmovg P2, P1
