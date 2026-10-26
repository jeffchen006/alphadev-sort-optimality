# n=5 model=out iset=I1 prefix14_class=4696
mov S2, P2
mov S1, P0
cmp P3, S2
cmovg S2, P3
cmovle P2, P3
cmp S1, P1
cmovg S1, P1
cmovle P0, P1
cmp P0, S2
cmovge P1, S2
cmovge S2, P0
cmovg P0, P1
cmp P2, S1
cmovle P1, P2
