# n=5 model=out iset=I1 prefix14_class=6101
cmp P0, P1
mov S2, P0
cmovle S2, P1
cmovle P1, P0
cmp P3, P2
cmovge S0, P3
cmovle S0, P2
cmovg P3, P2
mov P0, S0
cmp P0, S2
cmovg S0, S2
cmovge S2, P0
cmp P3, P1
cmovge S2, P1
