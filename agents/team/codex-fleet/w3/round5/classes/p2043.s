# n=5 model=out iset=I1 prefix14_class=2043
mov S2, P1
cmp P0, P1
cmovg P1, P0
cmovle S2, P0
mov P0, S2
cmp P3, P2
cmovge S1, P3
cmovg P3, P2
cmovg P2, S1
mov S0, P2
cmp S0, P1
cmovg P2, P1
cmovle S0, P1
cmovle P1, P2
