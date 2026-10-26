# n=5 model=out iset=I1 prefix14_class=12771
mov S1, P1
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmovle P0, S0
cmp P2, P1
cmovle S1, P2
mov S2, S1
cmovge P1, P2
cmovle P2, P1
cmp S1, P3
cmovge S2, P3
cmovg P3, S1
cmovle S1, P3
