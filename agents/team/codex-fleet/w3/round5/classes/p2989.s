# n=5 model=out iset=I1 prefix14_class=2989
cmp P2, P1
cmovg S1, P2
cmovle S1, P1
cmovle P1, P2
cmp P3, P0
cmovg S2, P3
cmovge P3, P0
cmovg P0, S2
cmp S1, P0
mov S0, S1
cmovg S0, P0
cmovg P0, S1
cmp P1, P3
cmovge S2, P1
