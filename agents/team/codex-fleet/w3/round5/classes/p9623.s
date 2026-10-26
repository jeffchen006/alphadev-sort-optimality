# n=5 model=out iset=I1 prefix14_class=9623
mov S2, P2
mov S1, P0
cmp P2, P3
cmovg P2, P3
cmovge P3, S2
cmp S1, P1
cmovle P0, P1
cmovg S1, P1
mov S2, P3
cmp P0, P3
cmovge P3, P0
cmovl S2, P0
cmp P2, S1
cmovle P3, S1
