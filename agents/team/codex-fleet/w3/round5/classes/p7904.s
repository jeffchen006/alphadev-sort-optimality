# n=5 model=out iset=I1 prefix14_class=7904
cmp P2, P1
cmovle S1, P2
cmovle P2, P1
cmovg S1, P1
cmp P0, P3
mov P1, P2
cmovg S2, P3
cmovg P3, P0
cmovle S2, P0
cmp S2, S1
cmovge S0, S2
cmovge S2, S1
cmovg S1, S0
cmp P1, P3
