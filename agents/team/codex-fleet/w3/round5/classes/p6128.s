# n=5 model=out iset=I1 prefix14_class=6128
cmp P1, P2
mov S1, P2
cmovle P2, P1
cmovle P1, S1
mov S1, P3
cmp P0, S1
cmovg P3, P0
cmovge P0, S1
cmp P1, P3
cmovg S1, P1
mov S0, P0
cmovge P1, P3
cmovg P3, S1
cmp P2, P0
