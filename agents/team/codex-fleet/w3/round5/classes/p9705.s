# n=5 model=out iset=I1 prefix14_class=9705
mov S0, P1
cmp P3, S0
mov S1, P2
cmovg S0, P3
cmovge P3, P1
cmp P0, P2
cmovge S1, P0
cmovge P0, P2
cmp S1, S0
cmovle P1, S0
cmovle S0, S1
cmovle S1, P1
cmp P0, P3
cmovle S1, P0
