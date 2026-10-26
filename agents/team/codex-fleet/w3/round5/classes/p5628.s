# n=5 model=out iset=I1 prefix14_class=5628
cmp P3, P2
mov S2, P2
cmovg S2, P3
cmovge P3, P2
cmp P1, P0
cmovle P2, P1
cmovl P1, P0
cmovle P0, P2
mov S1, P3
cmp S1, P0
cmovg P3, P0
cmovg P0, S1
cmp S2, P1
cmovge P3, S2
