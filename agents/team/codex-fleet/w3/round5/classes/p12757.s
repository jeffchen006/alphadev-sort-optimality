# n=5 model=out iset=I1 prefix14_class=12757
mov S2, P2
cmp P1, S2
mov S1, P3
cmovge P2, P1
cmovg P1, S2
cmp P0, S1
cmovle S1, P0
cmovge P3, P0
cmp S1, P1
cmovg S2, P1
cmovge P1, S1
cmovg S1, S2
cmp P3, P2
mov P0, P1
