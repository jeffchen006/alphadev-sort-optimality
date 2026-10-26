# n=5 model=out iset=I1 prefix14_class=1526
cmp P3, P1
cmovge S0, P1
cmovle S0, P3
cmovg P1, P3
cmp P0, P2
cmovle S2, P0
cmovge S2, P2
cmovg P2, P0
cmp S2, S0
cmovge S1, S2
cmovge S2, S0
cmovg S0, S1
cmp P2, P1
cmovle P3, P2
