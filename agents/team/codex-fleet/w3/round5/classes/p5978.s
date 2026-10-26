# n=5 model=out iset=I1 prefix14_class=5978
cmp P0, P3
cmovge S1, P3
cmovge P3, P0
cmovl S1, P0
cmp P1, P2
mov S2, S1
mov P0, P1
cmovg P0, P2
cmovg P2, P1
cmp P3, P2
cmovle P1, P2
cmovle P2, P3
cmovle P3, P1
cmp P0, S2
