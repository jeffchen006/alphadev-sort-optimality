# n=5 model=out iset=I1 prefix14_class=9638
cmp P3, P2
cmovge S2, P3
cmovge P3, P2
cmovg P2, S2
mov S2, P0
cmp S2, P1
cmovg S2, P1
cmovle P0, P1
cmp P0, P2
cmovle P1, P0
cmovle P0, P2
mov P0, P3
cmovle P2, P1
cmp P3, S2
