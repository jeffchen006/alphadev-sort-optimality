# n=5 model=out iset=I1 prefix14_class=346
mov S1, P2
cmp S1, P3
cmovg P2, P3
cmovg P3, S1
mov S1, P0
cmp P0, P1
cmovg P0, P1
mov S2, P0
cmovge P1, S1
cmp P2, P0
cmovl S2, P2
cmovle P2, P0
mov S2, P3
cmp P1, P3
