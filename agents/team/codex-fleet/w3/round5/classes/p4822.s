# n=5 model=out iset=I1 prefix14_class=4822
cmp P3, P2
mov S0, P2
cmovg S0, P3
cmovle P2, P3
cmp P0, P1
cmovge S1, P0
mov S2, P2
cmovge P0, P1
cmovge P1, S1
cmp P0, S2
cmovg P2, P0
cmovle S2, P0
cmp P1, S0
mov P0, P2
