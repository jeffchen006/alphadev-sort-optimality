# n=5 model=out iset=I1 prefix14_class=1664
mov S0, P3
mov S2, P1
cmp P2, S2
cmovg P1, P2
cmovg P2, S2
cmp P3, P0
cmovge P3, P0
cmovg P0, S0
cmp P2, P3
mov S2, P2
cmovle P2, P3
cmovle P3, S2
cmp P0, P1
cmovg S1, P0
