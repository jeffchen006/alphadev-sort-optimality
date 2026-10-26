# n=5 model=out iset=I1 prefix14_class=2236
mov S1, P1
cmp P3, P1
cmovg P1, P3
cmovge P3, S1
cmp P2, P0
mov S1, P0
cmovg S1, P2
mov S2, S1
cmovge P2, P0
cmp S2, P1
cmovl S1, P1
cmovle P1, S2
cmp P3, P2
cmovl S1, P3
