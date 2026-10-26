# n=5 model=out iset=I1 prefix14_class=13908
cmp P2, P0
cmovle S0, P0
cmovle P0, P2
cmovle P2, S0
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
cmovg P1, S1
cmp P3, P2
cmovge S1, P2
mov S0, P1
cmovg P2, P3
cmovg P3, S1
cmp S0, P0
