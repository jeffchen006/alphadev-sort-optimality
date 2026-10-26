# n=5 model=out iset=I1 prefix14_class=1009
mov S2, P1
cmp S2, P2
cmovle S2, P2
cmovle P2, P1
mov P1, S2
cmp P0, P3
cmovg S1, P0
cmovge P0, P3
cmovg P3, S1
cmp P3, P1
cmovge S2, P3
cmovg P3, P1
mov S0, P0
cmp P2, S0
