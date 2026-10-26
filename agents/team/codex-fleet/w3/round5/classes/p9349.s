# n=5 model=out iset=I1 prefix14_class=9349
mov S2, P1
mov S1, P3
cmp P2, S2
cmovle P1, P2
cmovle P2, S2
cmp P0, P3
cmovle P3, P0
mov S2, P2
cmovle P0, S1
cmp P3, P1
cmovge S1, P1
cmovg P1, P3
cmovg P3, S1
cmp P0, P2
