# n=5 model=out iset=I1 prefix14_class=8831
cmp P3, P1
mov S1, P3
cmovg P3, P1
cmovle S1, P1
mov P1, P0
cmp P2, P1
cmovge P1, P2
cmovle P0, P2
cmp S1, P1
cmovge P2, S1
cmovge S1, P1
cmovg P1, P2
cmp P0, P3
cmovge S0, P0
