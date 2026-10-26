# n=5 model=out iset=I1 prefix14_class=2848
cmp P2, P1
cmovle S1, P2
mov S2, P3
cmovg S1, P1
cmovle P2, P1
cmp S2, P0
cmovg S2, P0
cmovg P0, P3
mov P3, P0
cmp P0, P2
cmovge P3, P2
cmovge P2, P0
mov P2, P3
cmp S2, S1
