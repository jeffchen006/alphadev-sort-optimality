# n=5 model=out iset=I1 prefix14_class=5288
mov S0, P3
cmp S0, P2
mov S1, P0
cmovle P3, P2
cmovg S0, P2
cmp P0, P1
cmovge S1, P1
cmovle P0, P1
cmp S1, S0
mov P2, S0
cmovle P2, S1
cmovg S0, S1
cmp P0, P3
cmovle S1, S0
