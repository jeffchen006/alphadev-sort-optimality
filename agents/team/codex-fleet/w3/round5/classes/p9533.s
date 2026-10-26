# n=5 model=out iset=I1 prefix14_class=9533
cmp P0, P1
cmovle S0, P0
cmovle P0, P1
mov S2, P0
cmovge S0, P1
cmp P2, P3
cmovge P1, P2
cmovge P2, P3
mov S1, S0
cmovg P3, P1
cmp S1, P2
cmovle S0, P2
cmovg S1, P2
cmp S2, P3
