# n=5 model=out iset=I1 prefix14_class=2800
mov S2, P0
cmp P1, P2
mov S1, P1
cmovg P1, P2
cmovg P2, S1
cmp P3, P0
cmovle P0, P3
cmovle P3, S2
cmp P3, P2
cmovg S2, P2
cmovg P2, P3
mov P2, P0
cmovg P3, S2
mov S1, P3
