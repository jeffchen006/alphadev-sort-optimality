# n=5 model=out iset=I1 prefix14_class=6326
mov S1, P1
cmp P1, P3
cmovge S1, P3
cmovge P3, P1
cmp P0, P2
cmovle P1, P0
cmovle P0, P2
cmovle P2, P1
mov S2, P0
cmp P0, P3
cmovle P0, P3
cmovge S2, P3
cmp P2, S1
cmovg P3, S1
