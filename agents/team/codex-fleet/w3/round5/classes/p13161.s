# n=5 model=out iset=I1 prefix14_class=13161
cmp P0, P1
cmovge S0, P1
cmovge P1, P0
cmovg P0, S0
cmp P3, P2
cmovge S1, P3
cmovge P3, P2
cmovle S1, P2
cmp P0, P3
mov S2, P3
cmovle P3, P0
cmovge S2, P0
mov P3, P1
cmp S1, P3
