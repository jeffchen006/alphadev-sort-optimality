# n=5 model=out iset=I1 prefix14_class=13638
mov S0, P1
cmp P2, P1
cmovle P1, P2
cmovg S0, P2
mov S2, P0
cmp S2, P3
cmovg P0, P3
cmovle S2, P3
cmp P1, P0
mov P2, S0
cmovge S1, P0
cmovge P0, P1
cmovg P1, S1
cmp P2, S2
