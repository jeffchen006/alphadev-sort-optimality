# n=5 model=out iset=I1 prefix14_class=2809
mov S1, P1
cmp S1, P0
cmovge S1, P0
mov S2, P2
cmovg P0, P1
cmp P3, S2
cmovle P2, P3
cmovle P3, S2
cmp P3, P0
cmovg S2, P0
cmovge P0, P3
cmovg P3, S2
cmp P2, S1
cmovle S2, P2
