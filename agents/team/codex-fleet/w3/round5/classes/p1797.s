# n=5 model=out iset=I1 prefix14_class=1797
cmp P1, P3
mov S2, P3
cmovge S2, P1
cmovg P1, P3
cmp P0, P2
cmovge S1, P0
cmovg P0, P2
cmovle S1, P2
cmp S1, S2
mov P2, S2
cmovle S2, S1
cmovle S1, P2
mov S1, P1
cmp P0, P1
