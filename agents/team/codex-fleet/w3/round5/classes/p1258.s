# n=5 model=out iset=I1 prefix14_class=1258
mov S2, P3
cmp P0, P3
cmovge S2, P0
cmovg P0, P3
cmp P2, P1
mov S0, S2
cmovg S1, P2
cmovle S1, P1
cmovle P1, P2
cmp S2, S1
cmovle S0, S1
cmovg S2, S1
mov P3, P0
mov P2, S2
