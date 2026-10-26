# n=5 model=out iset=I1 prefix14_class=920
cmp P2, P3
cmovle S0, P3
cmovge S0, P2
cmovle P3, P2
cmp P0, P1
mov S1, S0
mov S2, P0
cmovge S2, P1
cmovge P1, P0
cmp P1, S1
cmovge S1, P1
cmovge P1, S0
mov S1, S2
cmovle S0, P1
