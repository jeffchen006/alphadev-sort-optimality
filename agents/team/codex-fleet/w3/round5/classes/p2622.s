# n=5 model=out iset=I1 prefix14_class=2622
cmp P0, P1
cmovge S2, P1
cmovge P1, P0
mov S1, P3
cmovg P0, S2
cmp P2, P3
cmovg S1, P2
cmovle P3, P2
cmp S1, P1
mov P2, P3
mov S0, P1
cmovle P1, S1
cmovle S1, S0
cmp P0, P3
