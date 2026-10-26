# n=5 model=out iset=I1 prefix14_class=4407
cmp P2, P1
cmovle S1, P1
cmovg S1, P2
mov S0, P3
cmovg P2, P1
cmp S0, P0
cmovge S0, P0
cmovge P0, P3
cmp S1, P0
cmovge P1, P0
cmovle P1, S1
cmovle S1, P0
mov S1, P2
cmp P2, S0
