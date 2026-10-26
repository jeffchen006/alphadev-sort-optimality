# n=5 model=out iset=I1 prefix14_class=1456
mov S1, P0
cmp S1, P2
cmovg S1, P2
cmovg P2, P0
cmp P1, P3
cmovge P0, P1
cmovle P0, P3
cmovg P1, P3
cmp P2, P0
mov S0, P1
cmovge P3, P0
cmovge P0, P2
cmovge P2, P3
cmp P1, S1
