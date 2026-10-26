# n=5 model=out iset=I1 prefix14_class=317
mov S2, P2
cmp P1, P3
cmovg S1, P1
cmovge P1, P3
cmovg P3, S1
cmp P0, S2
cmovg S2, P0
cmovl P2, P0
cmp P1, P2
cmovle P0, P1
cmovge P0, P2
cmovle P1, P2
cmp S2, P3
mov S0, P1
