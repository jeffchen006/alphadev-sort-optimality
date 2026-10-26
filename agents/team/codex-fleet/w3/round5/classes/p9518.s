# n=5 model=out iset=I1 prefix14_class=9518
cmp P0, P2
cmovle S2, P0
cmovg S2, P2
mov S1, P3
cmovle P0, P2
cmp S1, P1
cmovg P3, P1
cmovg P1, S1
cmp S2, P3
cmovge P2, S2
cmovg S2, P3
cmovge P3, P2
mov S2, P0
cmp S2, P1
