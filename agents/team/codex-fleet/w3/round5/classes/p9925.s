# n=5 model=out iset=I1 prefix14_class=9925
mov S1, P1
cmp P2, S1
cmovg P1, P2
cmovg P2, S1
mov S0, P0
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmp S0, P1
cmovge P0, P1
mov S2, P2
cmovge P1, S0
cmovg S0, P0
cmp S2, P3
