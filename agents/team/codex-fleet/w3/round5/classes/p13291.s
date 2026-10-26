# n=5 model=out iset=I1 prefix14_class=13291
cmp P2, P3
cmovle S1, P3
cmovle P3, P2
cmovle P2, S1
mov S0, P1
cmp P0, S0
cmovle S0, P0
cmovle P0, P1
cmp P3, S0
cmovle S2, P3
mov P1, P2
cmovg S2, S0
cmovge S0, P3
mov P3, S0
