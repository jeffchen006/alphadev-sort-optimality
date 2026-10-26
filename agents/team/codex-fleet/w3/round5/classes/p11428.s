# n=5 model=out iset=I1 prefix14_class=11428
cmp P1, P3
mov S1, P3
cmovge S1, P1
cmovge P1, P3
cmp P2, P0
mov P3, P2
cmovg P2, P0
cmovg P0, P3
cmp P2, P1
cmovg P3, P2
cmovle P3, P1
cmovl P1, P2
cmp S1, P0
cmovge P2, P0
