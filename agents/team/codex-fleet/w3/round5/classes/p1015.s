# n=5 model=out iset=I1 prefix14_class=1015
mov S1, P1
cmp S1, P0
cmovle S1, P0
cmovle P0, P1
cmp P3, P2
mov P1, S1
mov S2, P3
cmovg S2, P2
cmovge P2, P3
cmp P2, P1
cmovg S1, P2
cmovg P2, P1
cmp P0, S2
cmovge S1, P0
