# n=5 model=out iset=I1 prefix14_class=13717
cmp P2, P1
cmovge S1, P2
cmovge P2, P1
mov S2, P2
cmovle S1, P1
cmp P3, P0
cmovle S0, P0
cmovg S0, P3
cmovle P0, P3
cmp S0, S1
cmovg P1, S1
cmovge S1, S0
cmovg S0, P1
cmp P0, P2
