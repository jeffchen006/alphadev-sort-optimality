# n=5 model=out iset=I1 prefix14_class=9535
mov S1, P1
cmp S1, P2
cmovge S1, P2
mov S2, P3
cmovle P1, P2
cmp P0, P3
cmovge S2, P0
cmovge P0, P3
mov S0, S1
cmp S1, P0
cmovge S1, P0
cmovle S0, P0
cmp P1, S2
cmovg P2, S2
