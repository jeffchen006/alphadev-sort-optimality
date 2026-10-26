# n=5 model=out iset=I1 prefix14_class=11460
cmp P2, P0
mov S1, P2
cmovle P2, P0
cmovg S1, P0
cmp P3, P1
cmovge P0, P3
cmovg P3, P1
mov S0, S1
cmovge P1, P0
cmp P3, S0
cmovg S0, P3
cmovge P3, S1
mov P3, P2
cmp P1, P2
