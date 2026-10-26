# n=5 model=out iset=I1 prefix14_class=5757
cmp P2, P3
cmovge S0, P3
cmovle S0, P2
cmovle P2, P3
mov P3, S0
mov S1, P1
cmp P1, P0
cmovg S1, P0
cmovge P0, P1
cmp S1, P3
cmovg P3, S1
cmovle S0, S1
cmp P2, P0
cmovle S1, P0
