# n=5 model=out iset=I1 prefix14_class=8843
cmp P2, P0
mov S1, P3
cmovge S2, P2
cmovg P2, P0
cmovge P0, S2
cmp P1, S1
cmovle P3, P1
cmovg S1, P1
cmp P0, S1
cmovle S0, S1
cmovge S0, P0
mov S0, P2
cmovle S1, P0
cmp S0, P3
